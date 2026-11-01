/// Regra exclusiva para o SUV com Suspensão Pneumática
class SuvAirSuspensionSafetyRule implements SafetyRule {
  @override
  CommandResult? validate(VehicleCommand command, Ref ref) {
    if (command.targetVssPath != Vss.Vehicle.Chassis.Suspension.Height) return null;

    final targetHeight = command.payload as String; // Ex: "OFFROAD_MAX"
    final speed = (ref.read(vssSignalProvider(Vss.Vehicle.Speed)) as num?)?.toDouble() ?? 0.0;

    if (targetHeight == 'OFFROAD_MAX' && speed > 50.0) {
      return CommandResult.rejected('Altura máxima de suspensão indisponível acima de 50 km/h.');
    }
    return null;
  }
}