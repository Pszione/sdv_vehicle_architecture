import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Prevents engaging PARK or REVERSE while the vehicle is moving.
final class TransmissionSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 5.0;
  static const _lowSpeedOnlyGears = {'PARK', 'REVERSE'};

  @override
  VssSignal<String> get target => Vss.Vehicle.Powertrain.Transmission.SelectedGear;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (!_lowSpeedOnlyGears.contains(command.value)) return null;

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected(
        'Slow down below ${maxSpeedKmh.toInt()} km/h to engage ${command.value} (current: ${speed.toInt()} km/h).',
      );
    }
    return null;
  }
}
