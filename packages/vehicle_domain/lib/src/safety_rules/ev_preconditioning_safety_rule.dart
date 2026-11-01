import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Bloqueia o pré-condicionamento da bateria com SoC baixo, para preservar autonomia.
final class EvPreconditioningSafetyRule implements SafetyRule {
  static const minStateOfCharge = 15.0;

  @override
  VssSignal<bool> get target => Vss.Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;

    // Sem leitura do BMS, assume SoC baixo (fail-safe).
    final soc = signals.read(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge) ?? 0.0;
    if (soc < minStateOfCharge) {
      return CommandResult.rejected(
        'Bateria abaixo de ${minStateOfCharge.toInt()}%. Pré-condicionamento bloqueado para preservar autonomia.',
      );
    }
    return null;
  }
}
