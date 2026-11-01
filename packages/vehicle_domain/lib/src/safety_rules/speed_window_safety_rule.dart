import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Driver assists that can only be switched on inside a speed window.
final class SpeedWindowSafetyRule implements SafetyRule {
  SpeedWindowSafetyRule({required this.target, required this.label, this.minSpeedKmh, this.maxSpeedKmh});

  static List<SpeedWindowSafetyRule> all() => [
    SpeedWindowSafetyRule(target: Vss.Vehicle.ADAS.LaneKeepingAssist.IsEnabled, label: 'Lane keeping', minSpeedKmh: 60),
    SpeedWindowSafetyRule(
      target: Vss.Vehicle.ADAS.HillDescentControl.IsEnabled,
      label: 'Hill descent control',
      maxSpeedKmh: 30,
    ),
  ];

  @override
  final VssSignal<bool> target;
  final String label;
  final double? minSpeedKmh;
  final double? maxSpeedKmh;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (minSpeedKmh case final min? when speed < min) {
      return CommandResult.rejected('$label activates above ${min.toInt()} km/h (current: ${speed.toInt()} km/h).');
    }
    if (maxSpeedKmh case final max? when speed > max) {
      return CommandResult.rejected('$label works below ${max.toInt()} km/h (current: ${speed.toInt()} km/h).');
    }
    return null;
  }
}
