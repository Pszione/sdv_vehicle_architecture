import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../power/power_mode.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Powers the car off when the driver leaves it: PARK, driver seat empty and driver door open.
final class AutoPowerOffBehavior implements VehicleBehavior {
  static const source = 'AUTO_OFF';
  static const _poweredModes = {PowerMode.accessory, PowerMode.on, PowerMode.ready};

  @override
  Set<VssSignal<Object>> get triggers => {VehicleGroups.driverSeat.occupancy, VehicleGroups.driverDoor.open};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    final hasDriverLeft =
        after.read(VehicleGroups.driverSeat.occupancy) == SeatOccupancy.empty &&
        (after.read(VehicleGroups.driverDoor.open) ?? false);
    final wasPresent =
        before.read(VehicleGroups.driverSeat.occupancy) != SeatOccupancy.empty ||
        !(before.read(VehicleGroups.driverDoor.open) ?? false);
    if (!hasDriverLeft || !wasPresent) return const [];
    if (!_poweredModes.contains(PowerMode.from(after))) return const [];
    if (after.read(Vss.Vehicle.Powertrain.Transmission.SelectedGear) != Gear.park) return const [];

    return [VehicleCommand(signal: Vss.Vehicle.PowerMode.Request, value: PowerModeRequest.off, source: source)];
  }
}
