import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/fail_safe.dart';
import 'domain/safety_rule.dart';

/// Prevents leaving PARK/NEUTRAL while the charging cable is connected.
final class EvChargingSafetyRule implements SafetyRule {
  static const _stationaryGears = {Gear.park, Gear.neutral};

  @override
  VssSignal<int> get target => Vss.Vehicle.Powertrain.Transmission.SelectedGear;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (_stationaryGears.contains(command.value)) return null;

    final isCableConnected = signals.read(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected);
    if (isCableConnected == null) return FailSafe.chargingCableUnavailable;
    if (isCableConnected) {
      return const CommandResult.rejected('Cannot engage a gear: the charging cable is still connected.');
    }
    return null;
  }
}
