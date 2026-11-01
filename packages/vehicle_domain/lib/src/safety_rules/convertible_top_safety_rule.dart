class ConvertibleTopSafetyRule implements SafetyRule {
  @override
  CommandResult? validate(VehicleCommand command, Ref ref) {
    final topPath = Vss.Vehicle.Cabin.ConvertibleTop.Position;
    if (command.targetVssPath != topPath) return null;

    if (!ref.read(isSignalSupportedProvider(topPath))) return null;

    final isTrunkAjar = ref.read(vssSignalProvider(Vss.Vehicle.Body.Trunk.IsAjar)) as bool? ?? false;
    final speed = (ref.read(vssSignalProvider(Vss.Vehicle.Speed)) as num?)?.toDouble() ?? 0.0;
    final temp = (ref.read(vssSignalProvider(Vss.Vehicle.Exterior.AirTemperature)) as num?)?.toDouble() ?? 20.0;

    if (isTrunkAjar) {
      return CommandResult.rejected('Não é possível operar a capota com o porta-malas aberto.');
    }

    if (speed > 50.0) {
      return CommandResult.rejected('Operação da capota bloqueada acima de 50 km/h.');
    }

    if (temp <= 0.0) {
      return CommandResult.rejected('Temperatura externa muito baixa. Risco de dano ao mecanismo da capota.');
    }

    return null;
  }
}