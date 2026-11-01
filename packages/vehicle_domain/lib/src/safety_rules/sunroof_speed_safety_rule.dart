import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Bloqueia a abertura do teto solar acima de 120 km/h. Fechar é sempre permitido.
final class SunroofSpeedSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 120.0;

  @override
  VssSignal<double> get target => Vss.Vehicle.Cabin.Sunroof.Position;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if ((command.value as double) <= 0.0) return null;

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected('Velocidade acima de ${maxSpeedKmh.toInt()} km/h. Teto solar bloqueado.');
    }
    return null;
  }
}
