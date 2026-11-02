import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/vehicle_behavior.dart';

/// Post-crash response: unlocks every door for rescuers and turns on the hazard lights.
final class CrashResponseBehavior implements VehicleBehavior {
  static const source = 'CRASH_RESPONSE';

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Body.IsCrashDetected};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    if (!after.becameEqual(before, Vss.Vehicle.Body.IsCrashDetected, true)) return const [];
    return [
      for (final door in VehicleGroups.doors) VehicleCommand(signal: door.lock, value: false, source: source),
      VehicleCommand(signal: Vss.Vehicle.Body.Lights.Hazard.IsSignaling, value: true, source: source),
    ];
  }
}
