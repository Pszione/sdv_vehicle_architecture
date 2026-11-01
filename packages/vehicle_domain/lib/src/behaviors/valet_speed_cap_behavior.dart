import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../safety_rules/valet_mode_safety_rule.dart';
import 'domain/vehicle_behavior.dart';

/// Turning Valet Mode on caps the speed limiter at the valet maximum.
final class ValetSpeedCapBehavior implements VehicleBehavior {
  static const source = 'VALET';

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Cabin.ValetMode.IsEnabled};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    if (!after.becameEqual(before, Vss.Vehicle.Cabin.ValetMode.IsEnabled, true)) return const [];
    return [
      VehicleCommand(
        signal: Vss.Vehicle.ADAS.SpeedLimiter.SetSpeed,
        value: ValetModeSafetyRule.maxSpeedKmh,
        source: source,
      ),
    ];
  }
}
