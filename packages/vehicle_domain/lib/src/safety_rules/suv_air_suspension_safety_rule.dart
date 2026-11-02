import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/fail_safe.dart';
import 'domain/safety_rule.dart';

/// Maximum air suspension height (OFFROAD_MAX) is only available below 50 km/h.
final class SuvAirSuspensionSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 50.0;
  static const offroadMax = SuspensionHeight.offroadMax;

  @override
  VssSignal<String> get target => Vss.Vehicle.Chassis.Suspension.Height;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != offroadMax) return null;

    final speed = signals.read(Vss.Vehicle.Speed);
    if (speed == null) return FailSafe.speedUnavailable;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected(
        'Off-road max height is unavailable above ${maxSpeedKmh.toInt()} km/h (current: ${speed.toInt()} km/h).',
      );
    }
    return null;
  }
}
