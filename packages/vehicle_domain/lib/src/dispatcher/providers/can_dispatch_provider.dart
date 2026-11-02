import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../broker/providers/vss_value_provider.dart';
import '../../e2e/providers/signal_status_provider.dart';
import '../../power/providers/power_mode_provider.dart';
import '../../profile/providers/active_vehicle_profile.dart';
import '../../safety_rules/providers/safety_rules_provider.dart';
import '../command_dispatcher.dart';
import '../domain/vehicle_commands.dart';

part 'can_dispatch_provider.g.dart';

/// Re-evaluates whether [command] would be approved right now, to warn the
/// user before they tap a control.
///
/// Only watches the profile, the power mode and the `inputs` (value and status) of the
/// rules that apply to the command, so telemetry of unrelated signals does not trigger a re-evaluation.
@riverpod
CommandResult canDispatch(Ref ref, VehicleCommand<Object> command) {
  ref
    ..watch(activeVehicleProfileProvider)
    ..watch(powerModeProvider);
  for (final rule in ref.watch(activeSafetyRulesProvider)) {
    if (rule.target != command.signal) continue;
    for (final input in rule.inputs) {
      ref
        ..watch(vssValueProvider(input))
        ..watch(signalStatusProvider(input));
    }
  }
  return ref.read(commandDispatcherProvider.notifier).evaluate(command);
}
