import 'package:meta/meta.dart';

import '../../vss/vss_signal.dart';

enum CommandStatus {
  approved,
  rejectedBySafetyRule,
  notSupportedByVehicle,
  readOnlySignal,
  invalidPayload,

  /// The function does not exist in the current power mode (e.g. cruise control while not READY).
  unavailableInPowerMode,
}

@immutable
final class CommandResult {
  const CommandResult._(this.status, [this.message]);

  /// Command approved and sent to the zonal bus. Physical confirmation arrives
  /// later, as telemetry in the `VssBroker`.
  const CommandResult.approved() : this._(CommandStatus.approved);

  const CommandResult.rejected(String reason) : this._(CommandStatus.rejectedBySafetyRule, reason);

  CommandResult.notSupported(String vssPath)
    : this._(CommandStatus.notSupportedByVehicle, '"$vssPath" is not available on this vehicle.');

  CommandResult.readOnly(String vssPath)
    : this._(CommandStatus.readOnlySignal, '"$vssPath" is a sensor and does not accept commands.');

  CommandResult.invalidPayload(String vssPath, Object value)
    : this._(CommandStatus.invalidPayload, 'Value "$value" is not allowed for "$vssPath".');

  const CommandResult.unavailableInPowerMode(String hint) : this._(CommandStatus.unavailableInPowerMode, hint);

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

/// Intent to change an actuator. The type of [value] is enforced by the signal.
@immutable
final class VehicleCommand<T extends Object> {
  const VehicleCommand({required this.signal, required this.value, this.source = 'UNKNOWN'});

  final VssSignal<T> signal;
  final T value;

  /// Origin of the command, e.g. "INFOTAINMENT_UI", "MOBILE_APP", "ADAS".
  final String source;

  @override
  bool operator ==(Object other) =>
      other is VehicleCommand && other.signal == signal && other.value == value && other.source == source;

  @override
  int get hashCode => Object.hash(signal, value, source);

  @override
  String toString() => 'VehicleCommand($signal = $value, source: $source)';
}
