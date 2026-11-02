import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/fail_safe.dart';
import 'domain/safety_rule.dart';

/// Blocks sliding the sunroof open above 120 km/h. Closing and tilting (negative %) are always allowed.
final class SunroofSpeedSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 120.0;

  @override
  VssSignal<int> get target => Vss.Vehicle.Cabin.Sunroof.Position;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if ((command.value as int) <= 0) return null;

    final speed = signals.read(Vss.Vehicle.Speed);
    if (speed == null) return FailSafe.speedUnavailable;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected(
        'Sunroof cannot open above ${maxSpeedKmh.toInt()} km/h (current: ${speed.toInt()} km/h).',
      );
    }
    return null;
  }
}
