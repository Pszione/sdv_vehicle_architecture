import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/vehicle_behavior.dart';

/// Speed-sensing auto-lock: locks every unlocked door when the car goes above 15 km/h.
/// A door that is open is rejected by `DoorSafetyRule` and shows up in the audit log.
final class SpeedAutoLockBehavior implements VehicleBehavior {
  static const source = 'AUTO_LOCK';
  static const speedKmh = 15.0;

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Speed};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    if (!after.crossedAbove(before, Vss.Vehicle.Speed, speedKmh)) return const [];
    return [
      for (final door in VehicleGroups.doors)
        if (after.read(door.lock) == false) VehicleCommand(signal: door.lock, value: true, source: source),
    ];
  }
}
