import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../profile/vehicle_profile.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';
/// Auto-park: in DRIVE, almost stopped, the driver opens the door with the
/// seatbelt unfastened -> engage PARK so the car cannot roll away.
final class AutoParkBehavior implements VehicleBehavior {
  AutoParkBehavior(this.driverSide);

  static const source = 'AUTO_PARK';
  static const maxSpeedKmh = 3.0;

  final DriverSide driverSide;

  @override
  Set<VssSignal<Object>> get triggers => {
    VehicleGroups.driverDoor(driverSide).ajar,
    VehicleGroups.driverSeat(driverSide).belted,
  };

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    final gear = Vss.Vehicle.Powertrain.Transmission.SelectedGear;
    final isLeaving =
        (after.read(VehicleGroups.driverDoor(driverSide).ajar) ?? false) &&
        !(after.read(VehicleGroups.driverSeat(driverSide).belted) ?? true);
    final isDriveEngaged = after.read(gear) == Gear.drive || after.read(gear) == Gear.reverse;
    final isAlmostStopped = (after.read(Vss.Vehicle.Speed) ?? 0) <= maxSpeedKmh;

    if (!isLeaving || !isDriveEngaged || !isAlmostStopped) return const [];
    return [VehicleCommand(signal: gear, value: Gear.park, source: source)];
  }
}
