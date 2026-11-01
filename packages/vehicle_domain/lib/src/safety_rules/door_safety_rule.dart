class DoorSafetyRule implements SafetyRule {
  @override
  CommandResult? validate(VehicleCommand command, Ref ref) {
    // 1. Define a referência tipada da porta
    final leftDoor = Vss.Vehicle.Cabin.Door.Row1.Left;

    // 2. Valida se o comando é direcionado para a trava desta porta
    if (command.targetVssPath != leftDoor.IsLocked) return null;
    if (command.payload != true) return null;

    // 3. Lê o sinal de porta aberta de forma fortemente tipada
    final isAjar = ref.read(vssSignalProvider(leftDoor.IsAjar));

    if (isAjar == true) {
      return CommandResult.rejected('Porta dianteira esquerda está aberta. Trava bloqueada.');
    }
    return null;
  }
}