import '../../broker/signal_reader.dart';
import '../../dispatcher/domain/vehicle_commands.dart';
import '../../vss/vss_signal.dart';

/// Safety rule evaluated by the `CommandDispatcher` before any command reaches
/// the zonal bus.
///
/// The dispatcher only calls [validate] when the command targets [target] and
/// that signal exists in the profile, so rules never need to check the target's capability.
abstract interface class SafetyRule {
  /// Actuator this rule applies to.
  VssSignal<Object> get target;

  /// Signals read by [validate]. `canDispatchProvider` only re-evaluates when they change.
  Set<VssSignal<Object>> get inputs;

  /// `null` if the command is safe; `CommandResult.rejected(reason)` otherwise.
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals);
}
