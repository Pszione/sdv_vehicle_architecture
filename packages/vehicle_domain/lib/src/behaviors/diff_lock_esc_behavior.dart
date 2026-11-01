import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Keeps ESC and the rear differential lock from fighting each other:
/// when the lock is confirmed ESC goes OFF, and when it is released ESC goes
/// back to the mode the driver had before.
final class DiffLockEscBehavior implements VehicleBehavior {
  static const source = 'ESC_COORDINATOR';

  String? _modeBeforeDiffLock;

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    final diffLock = Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked;
    final esc = Vss.Vehicle.ADAS.ESC.Mode;

    if (after.becameEqual(before, diffLock, true)) {
      final current = after.read(esc);
      if (current == null || current == EscMode.off) return const [];
      _modeBeforeDiffLock = current;
      return [VehicleCommand(signal: esc, value: EscMode.off, source: source)];
    }
    if (after.becameEqual(before, diffLock, false)) {
      final previous = _modeBeforeDiffLock;
      _modeBeforeDiffLock = null;
      if (previous == null) return const [];
      return [VehicleCommand(signal: esc, value: previous, source: source)];
    }
    return const [];
  }
}
