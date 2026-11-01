import 'package:meta/meta.dart';

import '../../vss/vss_signal.dart';

enum CommandStatus { approved, rejectedBySafetyRule, notSupportedByVehicle, readOnlySignal, invalidPayload }

@immutable
final class CommandResult {
  const CommandResult._(this.status, [this.message]);

  /// Comando aprovado e enviado ao barramento zonal. A confirmação física
  /// chega depois, como telemetria no `VssBroker`.
  const CommandResult.approved() : this._(CommandStatus.approved);

  const CommandResult.rejected(String reason) : this._(CommandStatus.rejectedBySafetyRule, reason);

  CommandResult.notSupported(String vssPath)
    : this._(CommandStatus.notSupportedByVehicle, 'O recurso "$vssPath" não existe neste veículo.');

  CommandResult.readOnly(String vssPath)
    : this._(CommandStatus.readOnlySignal, '"$vssPath" é um sensor e não aceita comandos.');

  CommandResult.invalidPayload(String vssPath, Object value)
    : this._(CommandStatus.invalidPayload, 'Valor "$value" fora do permitido para "$vssPath".');

  final CommandStatus status;
  final String? message;

  bool get isSuccess => status == CommandStatus.approved;

  @override
  bool operator ==(Object other) => other is CommandResult && other.status == status && other.message == message;

  @override
  int get hashCode => Object.hash(status, message);

  @override
  String toString() => 'CommandResult(${status.name}${message == null ? '' : ': $message'})';
}

/// Intenção de alterar um atuador. O tipo de [value] é garantido pelo sinal.
@immutable
final class VehicleCommand<T extends Object> {
  const VehicleCommand({required this.signal, required this.value, this.source = 'UNKNOWN'});

  final VssSignal<T> signal;
  final T value;

  /// Origem do comando. Ex: "INFOTAINMENT_UI", "MOBILE_APP", "ADAS".
  final String source;

  @override
  bool operator ==(Object other) =>
      other is VehicleCommand && other.signal == signal && other.value == value && other.source == source;

  @override
  int get hashCode => Object.hash(signal, value, source);

  @override
  String toString() => 'VehicleCommand($signal = $value, source: $source)';
}
