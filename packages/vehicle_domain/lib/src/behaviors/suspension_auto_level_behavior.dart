import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Lowers the air suspension at highway speed for efficiency and stability, and
/// restores NORMAL when slowing down (only if it was this behavior that lowered it).
final class SuspensionAutoLevelBehavior implements VehicleBehavior {
  static const source = 'AUTO_LEVEL';
  static const lowerAboveKmh = 110.0;
  static const restoreBelowKmh = 80.0;

  bool _loweredAutomatically = false;

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Speed};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    final height = Vss.Vehicle.Chassis.Suspension.Height;
    final speed = Vss.Vehicle.Speed;

    if (after.crossedAbove(before, speed, lowerAboveKmh) && after.read(height) != SuspensionHeight.low) {
      _loweredAutomatically = true;
      return [VehicleCommand(signal: height, value: SuspensionHeight.low, source: source)];
    }
    if (_loweredAutomatically && after.crossedBelow(before, speed, restoreBelowKmh)) {
      _loweredAutomatically = false;
      return [VehicleCommand(signal: height, value: SuspensionHeight.normal, source: source)];
    }
    return const [];
  }
}
