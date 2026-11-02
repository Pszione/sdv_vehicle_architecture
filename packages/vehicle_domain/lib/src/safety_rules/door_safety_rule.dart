import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Blocks locking a door that is open. Unlocking is always allowed.
///
final class DoorSafetyRule implements SafetyRule {
  DoorSafetyRule({required VssSignal<bool> lock, required this.open, required this.label}) : target = lock;

  /// One rule per door in the spec.
  static List<DoorSafetyRule> allDoors() => [
    for (final door in VehicleGroups.doors) DoorSafetyRule(lock: door.lock, open: door.open, label: door.label),
  ];

  @override
  final VssSignal<bool> target;
  final VssSignal<bool> open;
  final String label;

  @override
  Set<VssSignal<Object>> get inputs => {open};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;
    if (signals.read(open) ?? false) {
      return CommandResult.rejected('$label door is open. Close it before locking.');
    }
    return null;
  }
}
