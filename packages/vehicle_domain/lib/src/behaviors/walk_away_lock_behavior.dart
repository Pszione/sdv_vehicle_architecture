import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../power/power_mode.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Walk-away lock: once the key has left the car's range *and* the car is off, lock every door.
///
/// Both orders count: the key can leave while accessories are still powered (retained
/// accessory power), and the car powers off a moment later.
final class WalkAwayLockBehavior implements VehicleBehavior {
  static const source = 'WALK_AWAY';
  static const _parkedModes = {PowerMode.off, PowerMode.sleep, PowerMode.charging};

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Body.Keyless.KeyLocation, ...PowerMode.inputs};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    if (!_isWalkedAway(after) || _isWalkedAway(before)) return const [];
    return [
      for (final door in VehicleGroups.doors)
        if (after.read(door.lock) == false) VehicleCommand(signal: door.lock, value: true, source: source),
    ];
  }

  static bool _isWalkedAway(SignalReader signals) =>
      signals.read(Vss.Vehicle.Body.Keyless.KeyLocation) == KeyLocation.none &&
      _parkedModes.contains(PowerMode.from(signals));
}
