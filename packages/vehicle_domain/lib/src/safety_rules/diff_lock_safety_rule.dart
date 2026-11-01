import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Only allows locking the rear differential at low speed with the steering
/// straight. Unlocking is always allowed.
final class DiffLockSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 30.0;
  static const maxSteeringAngleDeg = 15.0;

  @override
  VssSignal<bool> get target => Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed, Vss.Vehicle.Chassis.SteeringWheel.Angle};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected(
        'Slow down below ${maxSpeedKmh.toInt()} km/h to lock the differential (current: ${speed.toInt()} km/h).',
      );
    }

    final steeringAngle = (signals.read(Vss.Vehicle.Chassis.SteeringWheel.Angle) ?? 0.0).abs();
    if (steeringAngle > maxSteeringAngleDeg) {
      return CommandResult.rejected(
        'Straighten the steering wheel to lock the differential (current: ${steeringAngle.toInt()}°).',
      );
    }
    return null;
  }
}
