import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Altura máxima da suspensão pneumática (OFFROAD_MAX) só abaixo de 50 km/h.
final class SuvAirSuspensionSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 50.0;
  static const offroadMax = 'OFFROAD_MAX';

  @override
  VssSignal<String> get target => Vss.Vehicle.Chassis.Suspension.Height;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != offroadMax) return null;

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected('Altura máxima de suspensão indisponível acima de ${maxSpeedKmh.toInt()} km/h.');
    }
    return null;
  }
}
