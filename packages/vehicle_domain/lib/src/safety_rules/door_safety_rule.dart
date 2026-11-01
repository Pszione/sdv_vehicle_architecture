import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Blocks locking a door that is open. Unlocking is always allowed.
///
/// Uses the physical side (Left/Right), so it behaves the same on LHD and RHD.
final class DoorSafetyRule implements SafetyRule {
  DoorSafetyRule({required VssSignal<bool> lock, required this.ajar, required this.label}) : target = lock;

  /// One rule per door in the spec.
  static List<DoorSafetyRule> allDoors() => [
    for (final door in VehicleGroups.doors) DoorSafetyRule(lock: door.lock, ajar: door.ajar, label: door.label),
  ];

  @override
  final VssSignal<bool> target;
  final VssSignal<bool> ajar;
  final String label;

  @override
  Set<VssSignal<Object>> get inputs => {ajar};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;
    if (signals.read(ajar) ?? false) {
      return CommandResult.rejected('$label door is open. Close it before locking.');
    }
    return null;
  }
}
