import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Impede tirar o carro de PARK/NEUTRAL com o cabo de recarga conectado.
final class EvChargingSafetyRule implements SafetyRule {
  static const _stationaryGears = {'PARK', 'NEUTRAL'};

  @override
  VssSignal<String> get target => Vss.Vehicle.Powertrain.Transmission.SelectedGear;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (_stationaryGears.contains(command.value)) return null;

    if (signals.read(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected) ?? false) {
      return const CommandResult.rejected('Impossível engatar marcha: cabo de recarga ainda conectado.');
    }
    return null;
  }
}
