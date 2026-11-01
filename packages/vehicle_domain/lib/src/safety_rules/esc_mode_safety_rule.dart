import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// Electronic stability control (NORMAL, WET, SPORT_PLUS, OFF):
/// - with the rear differential locked, ESC must stay OFF (they fight each other);
/// - ESC can only be switched OFF below 50 km/h.
final class EscModeSafetyRule implements SafetyRule {
  static const maxSpeedToDisableKmh = 50.0;

  @override
  VssSignal<String> get target => Vss.Vehicle.ADAS.ESC.Mode;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked, Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    final isDiffLocked = signals.read(Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked) ?? false;
    if (isDiffLocked && command.value != EscMode.off) {
      return const CommandResult.rejected('Release the rear differential lock before re-enabling stability control.');
    }

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (command.value == EscMode.off && speed > maxSpeedToDisableKmh) {
      return CommandResult.rejected(
        'Stability control can only be turned off below ${maxSpeedToDisableKmh.toInt()} km/h '
        '(current: ${speed.toInt()} km/h).',
      );
    }
    return null;
  }
}
