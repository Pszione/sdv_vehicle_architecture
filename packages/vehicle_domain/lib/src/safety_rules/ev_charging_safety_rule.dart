class EvChargingSafetyRule implements SafetyRule {
  @override
  CommandResult? validate(VehicleCommand command, Ref ref) {
    final gearPath = Vss.Vehicle.Powertrain.Transmission.SelectedGear;
    if (command.targetVssPath != gearPath) return null;

    final targetGear = command.payload.toString();
    if (targetGear == 'PARK' || targetGear == 'NEUTRAL') return null;

    final isPlugConnected = ref.read(vssSignalProvider(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected)) as bool? ?? false;

    if (isPlugConnected) {
      return CommandResult.rejected('Impossível engatar marcha: Cabo de carregamento ainda está conectado à tomada.');
    }

    return null;
  }
}