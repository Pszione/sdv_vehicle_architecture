import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Unlocks every door when the driver shifts into PARK.
final class ParkAutoUnlockBehavior implements VehicleBehavior {
  static const source = 'AUTO_UNLOCK';

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Powertrain.Transmission.SelectedGear};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    if (!after.becameEqual(before, Vss.Vehicle.Powertrain.Transmission.SelectedGear, Gear.park)) return const [];
    return [
      for (final door in VehicleGroups.doors)
        if (after.read(door.lock) == true) VehicleCommand(signal: door.lock, value: false, source: source),
    ];
  }
}
