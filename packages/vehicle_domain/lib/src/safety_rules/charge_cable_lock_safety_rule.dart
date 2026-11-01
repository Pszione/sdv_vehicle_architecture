import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// The charge port keeps the cable locked while charging is in progress.
final class ChargeCableLockSafetyRule implements SafetyRule {
  @override
  VssSignal<bool> get target => Vss.Vehicle.Powertrain.TractionBattery.Charging.IsChargingCableLocked;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Powertrain.TractionBattery.Charging.IsCharging};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != false) return null;

    if (signals.read(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsCharging) ?? false) {
      return const CommandResult.rejected('Stop charging before releasing the charging cable.');
    }
    return null;
  }
}
