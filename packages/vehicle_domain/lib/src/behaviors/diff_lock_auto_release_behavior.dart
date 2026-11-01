import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/vehicle_behavior.dart';

/// Releases the rear differential lock above 40 km/h, so it never stays locked at speed.
final class DiffLockAutoReleaseBehavior implements VehicleBehavior {
  static const source = 'AUTO_RELEASE';
  static const speedKmh = 40.0;

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Speed};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    final diffLock = Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked;
    if (!after.crossedAbove(before, Vss.Vehicle.Speed, speedKmh) || after.read(diffLock) != true) return const [];
    return [VehicleCommand(signal: diffLock, value: false, source: source)];
  }
}
