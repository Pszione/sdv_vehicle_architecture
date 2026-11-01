import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../broker/providers/vss_value_provider.dart';
import '../../profile/providers/active_vehicle_profile.dart';
import '../../safety_rules/providers/safety_rules_provider.dart';
import '../command_dispatcher.dart';
import '../domain/vehicle_commands.dart';

part 'can_dispatch_provider.g.dart';

/// Reavalia se [command] seria aprovado agora, para habilitar ou desabilitar controles.
///
/// Só observa o perfil e os `inputs` das regras que se aplicam ao comando,
/// então telemetria de outros sinais não dispara reavaliação.
@riverpod
CommandResult canDispatch(Ref ref, VehicleCommand<Object> command) {
  ref.watch(activeVehicleProfileProvider);
  for (final rule in ref.watch(activeSafetyRulesProvider)) {
    if (rule.target != command.signal) continue;
    for (final input in rule.inputs) {
      ref.watch(vssValueProvider(input));
    }
  }
  return ref.read(commandDispatcherProvider.notifier).evaluate(command);
}
