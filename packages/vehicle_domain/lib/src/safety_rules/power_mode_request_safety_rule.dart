import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/fail_safe.dart';
import 'domain/safety_rule.dart';

/// Gates the driver's power requests, like a passive-start ECU:
/// - READY: key inside, brake pressed, charging cable unplugged.
/// - ON / ACC: key inside.
/// - OFF: stopped and in PARK (never power off while moving).
/// Nothing but OFF is accepted while a software update is installing.
final class PowerModeRequestSafetyRule implements SafetyRule {
  static const minBrakePercent = 10;
  static const maxPowerOffSpeedKmh = 3.0;

  @override
  VssSignal<String> get target => Vss.Vehicle.PowerMode.Request;

  @override
  Set<VssSignal<Object>> get inputs => {
    Vss.Vehicle.Body.Keyless.KeyLocation,
    Vss.Vehicle.Chassis.Brake.PedalPosition,
    Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected,
    Vss.Vehicle.Software.OTA.IsInstalling,
    Vss.Vehicle.Powertrain.Transmission.SelectedGear,
    Vss.Vehicle.Speed,
  };

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    final request = command.value as String;
    if (request == PowerModeRequest.off) return _validatePowerOff(signals);

    if (signals.read(Vss.Vehicle.Software.OTA.IsInstalling) ?? false) {
      return const CommandResult.rejected('Software update in progress. The vehicle cannot be used.');
    }
    // Cars without passive entry (signal not in the profile) are not blocked.
    final key = signals.read(Vss.Vehicle.Body.Keyless.KeyLocation) ?? KeyLocation.inside;
    if (key != KeyLocation.inside) {
      return const CommandResult.rejected('Key not detected inside the vehicle.');
    }
    if (request != PowerModeRequest.ready) return null;

    if ((signals.read(Vss.Vehicle.Chassis.Brake.PedalPosition) ?? 0) < minBrakePercent) {
      return const CommandResult.rejected('Press the brake pedal to start.');
    }
    final isCableConnected = signals.read(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected);
    if (isCableConnected == null) return FailSafe.chargingCableUnavailable;
    if (isCableConnected) return const CommandResult.rejected('Unplug the charging cable to drive.');
    return null;
  }

  CommandResult? _validatePowerOff(SignalReader signals) {
    final speed = signals.read(Vss.Vehicle.Speed);
    if (speed == null) return FailSafe.speedUnavailable;
    if (speed > maxPowerOffSpeedKmh) {
      return const CommandResult.rejected('Cannot power off while the vehicle is moving.');
    }
    final gear = signals.read(Vss.Vehicle.Powertrain.Transmission.SelectedGear);
    if (gear != null && gear != Gear.park) {
      return const CommandResult.rejected('Shift to PARK before powering off.');
    }
    return null;
  }
}
