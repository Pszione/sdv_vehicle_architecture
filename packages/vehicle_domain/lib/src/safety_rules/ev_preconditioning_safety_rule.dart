import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Blocks battery preconditioning on low SoC, to preserve range.
final class EvPreconditioningSafetyRule implements SafetyRule {
  static const minStateOfCharge = 15.0;

  @override
  VssSignal<bool> get target => Vss.Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;

    // Without a BMS reading, assume low SoC (fail-safe).
    final soc = signals.read(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge) ?? 0.0;
    if (soc < minStateOfCharge) {
      return CommandResult.rejected(
        'Battery below ${minStateOfCharge.toInt()}% (current: ${soc.toInt()}%). '
        'Preconditioning blocked to preserve range.',
      );
    }
    return null;
  }
}
