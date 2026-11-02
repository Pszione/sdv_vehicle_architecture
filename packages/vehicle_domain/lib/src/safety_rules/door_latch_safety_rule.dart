import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// The e-latch does not release a locked door: opening it by command needs an unlock first.
/// Closing is always allowed. Opening by hand (inner handle) is physical, not a command.
final class DoorLatchSafetyRule implements SafetyRule {
  DoorLatchSafetyRule({required VssSignal<bool> open, required this.lock, required this.label}) : target = open;

  /// One rule per door in the spec.
  static List<DoorLatchSafetyRule> allDoors() => [
    for (final door in VehicleGroups.doors) DoorLatchSafetyRule(open: door.open, lock: door.lock, label: door.label),
  ];

  @override
  final VssSignal<bool> target;
  final VssSignal<bool> lock;
  final String label;

  @override
  Set<VssSignal<Object>> get inputs => {lock};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;
    if (signals.read(lock) ?? false) {
      return CommandResult.rejected('$label door is locked. Unlock it before opening.');
    }
    return null;
  }
}
