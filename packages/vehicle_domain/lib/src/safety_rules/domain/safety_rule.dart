import '../../broker/signal_reader.dart';
import '../../dispatcher/domain/vehicle_commands.dart';
import '../../vss/vss_signal.dart';

/// Regra de segurança avaliada pelo `CommandDispatcher` antes de qualquer
/// comando chegar ao barramento zonal.
///
/// O dispatcher só chama [validate] quando o comando é para [target] e esse
/// sinal existe no perfil, então a regra não precisa checar a capacidade do alvo.
abstract interface class SafetyRule {
  /// Atuador ao qual a regra se aplica.
  VssSignal<Object> get target;

  /// Sinais lidos em [validate]. O `canDispatchProvider` só reavalia quando eles mudam.
  Set<VssSignal<Object>> get inputs;

  /// `null` se o comando é seguro; `CommandResult.rejected(motivo)` caso contrário.
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals);
}
