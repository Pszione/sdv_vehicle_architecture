import '../broker/signal_reader.dart';
import '../profile/vehicle_profile.dart';
import '../safety_rules/domain/safety_rule.dart';
import 'domain/vehicle_commands.dart';

/// Pipeline de validação puro (sem Riverpod), executado na ordem:
/// capacidade do perfil -> sinal comandável -> payload no spec -> safety rules.
/// A primeira falha encerra a validação.
final class CommandValidator {
  const CommandValidator({required this.profile, required this.signals, required this.rules});

  final VehicleProfile profile;
  final SignalReader signals;
  final List<SafetyRule> rules;

  CommandResult validate(VehicleCommand<Object> command) {
    final path = command.signal.path;
    final meta = profile.metaOf(command.signal);
    if (meta == null) return CommandResult.notSupported(path);
    if (!meta.isActuator) return CommandResult.readOnly(path);
    if (!meta.accepts(command.value)) return CommandResult.invalidPayload(path, command.value);

    for (final rule in rules) {
      if (rule.target != command.signal) continue;
      if (rule.validate(command, signals) case final rejection?) return rejection;
    }
    return const CommandResult.approved();
  }
}
