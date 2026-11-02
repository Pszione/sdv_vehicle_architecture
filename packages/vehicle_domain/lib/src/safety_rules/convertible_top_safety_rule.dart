import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/fail_safe.dart';
import 'domain/safety_rule.dart';

/// Convertible top operation: trunk closed, up to 50 km/h and above 0 °C.
final class ConvertibleTopSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 50.0;
  static const minTemperatureCelsius = 0.0;

  @override
  VssSignal<double> get target => Vss.Vehicle.Cabin.ConvertibleTop.Position;

  @override
  Set<VssSignal<Object>> get inputs => {
    Vss.Vehicle.Body.Trunk.Rear.IsOpen,
    Vss.Vehicle.Speed,
    Vss.Vehicle.Exterior.AirTemperature,
  };

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (signals.read(Vss.Vehicle.Body.Trunk.Rear.IsOpen) ?? false) {
      return const CommandResult.rejected('Close the trunk before operating the convertible top.');
    }

    final speed = signals.read(Vss.Vehicle.Speed);
    if (speed == null) return FailSafe.speedUnavailable;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected('Convertible top is locked above ${maxSpeedKmh.toInt()} km/h.');
    }

    // Without a temperature sensor in the model, do not block (previous behavior).
    final temperature = signals.read(Vss.Vehicle.Exterior.AirTemperature);
    if (temperature != null && temperature <= minTemperatureCelsius) {
      return const CommandResult.rejected('Outside temperature too low. Risk of damaging the top mechanism.');
    }
    return null;
  }
}
