import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Operação da capota: porta-malas fechado, até 50 km/h e acima de 0 °C.
final class ConvertibleTopSafetyRule implements SafetyRule {
  static const maxSpeedKmh = 50.0;
  static const minTemperatureCelsius = 0.0;

  @override
  VssSignal<double> get target => Vss.Vehicle.Cabin.ConvertibleTop.Position;

  @override
  Set<VssSignal<Object>> get inputs => {
    Vss.Vehicle.Body.Trunk.IsAjar,
    Vss.Vehicle.Speed,
    Vss.Vehicle.Exterior.AirTemperature,
  };

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (signals.read(Vss.Vehicle.Body.Trunk.IsAjar) ?? false) {
      return const CommandResult.rejected('Não é possível operar a capota com o porta-malas aberto.');
    }

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected('Operação da capota bloqueada acima de ${maxSpeedKmh.toInt()} km/h.');
    }

    // Sem sensor de temperatura no modelo, não bloqueia (mesmo comportamento anterior).
    final temperature = signals.read(Vss.Vehicle.Exterior.AirTemperature);
    if (temperature != null && temperature <= minTemperatureCelsius) {
      return const CommandResult.rejected('Temperatura externa muito baixa. Risco de dano ao mecanismo da capota.');
    }
    return null;
  }
}
