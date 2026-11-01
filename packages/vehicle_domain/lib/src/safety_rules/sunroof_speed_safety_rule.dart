class SunroofSpeedSafetyRule implements SafetyRule {
  @override
  CommandResult? validate(VehicleCommand command, Ref ref) {
    // 1. Checa se o comando é para o teto solar
    final sunroofPath = Vss.Vehicle.Cabin.Sunroof.Position;
    if (command.targetVssPath != sunroofPath) return null;

    // 2. GUARDA DE CAPACIDADE: Se o carro atual não tem teto solar, ignora a regra
    final isSupported = ref.read(isSignalSupportedProvider(sunroofPath));
    if (!isSupported) return null;

    // 3. Aplica a validação de segurança
    final double targetPos = (command.payload as num).toDouble();
    if (targetPos <= 0.0) return null; // Fechar sempre é permitido

    final speed = (ref.read(vssSignalProvider(Vss.Vehicle.Speed)) as num?)?.toDouble() ?? 0.0;
    if (speed > 120.0) {
      return CommandResult.rejected('Velocidade acima de 120 km/h. Teto solar bloqueado.');
    }

    return null;
  }
}