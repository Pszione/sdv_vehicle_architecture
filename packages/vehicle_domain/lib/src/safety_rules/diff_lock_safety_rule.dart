class DiffLockSafetyRule implements SafetyRule {
  @override
  CommandResult? validate(VehicleCommand command, Ref ref) {
    final diffLockPath = Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked;
    if (command.targetVssPath != diffLockPath) return null;
    if (command.payload != true) return null; // Desbloquear sempre é permitido

    final speed = (ref.read(vssSignalProvider(Vss.Vehicle.Speed)) as num?)?.toDouble() ?? 0.0;
    final steeringAngle = (ref.read(vssSignalProvider(Vss.Vehicle.Chassis.SteeringWheel.Angle)) as num?)?.abs().toDouble() ?? 0.0;

    // Regra 1: Velocidade
    if (speed > 30.0) {
      return CommandResult.rejected('Reduza a velocidade abaixo de 30 km/h para engatar (Atual: ${speed.toInt()} km/h).');
    }

    // Regra 2: Ângulo do Volante
    if (steeringAngle > 15.0) {
      return CommandResult.rejected('Alinhe a direção para engatar (Volante esterçado em ${steeringAngle.toInt()}°).');
    }

    return null;
  }
}