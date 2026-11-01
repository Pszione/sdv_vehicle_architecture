enum CommandStatus {
  executed,
  rejectedBySafetyRule,
  notSupportedByVehicle,
  invalidPayload,
}

class CommandResult {
  final CommandStatus status;
  final String? message;

  CommandResult._(this.status, [this.message]);

  factory CommandResult.executed() =>
      CommandResult._(CommandStatus.executed);

  factory CommandResult.rejected(String reason) =>
      CommandResult._(CommandStatus.rejectedBySafetyRule, reason);

  factory CommandResult.notSupported(String vssPath) =>
      CommandResult._(CommandStatus.notSupportedByVehicle, 'O recurso "$vssPath" não existe neste veículo.');

  bool get isSuccess => status == CommandStatus.executed;
}

class VehicleCommand {
  final String targetVssPath;
  final dynamic payload;
  final String source; // Ex: "INFOTAINMENT_UI", "MOBILE_APP", "ADAS"

  VehicleCommand({
    required this.targetVssPath,
    required this.payload,
    this.source = 'UNKNOWN',
  });
}