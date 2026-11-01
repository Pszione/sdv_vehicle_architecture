abstract class SafetyRule {
  /// Retorna null se o comando for seguro.
  /// Retorna CommandResult.rejected("motivo") se violar uma regra de segurança.
  CommandResult? validate(VehicleCommand command, Ref ref);
}