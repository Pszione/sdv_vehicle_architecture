class EvPreconditioningSafetyRule implements SafetyRule {
  @override
  CommandResult? validate(VehicleCommand command, Ref ref) {
    final precondPath = Vss.Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled;
    if (command.targetVssPath != precondPath) return null;
    if (command.payload != true) return null;

    if (!ref.read(isSignalSupportedProvider(precondPath))) return null;

    final batteryLevel = (ref.read(vssSignalProvider(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge)) as num?)?.toDouble() ?? 0.0;

    if (batteryLevel < 15.0) {
      return CommandResult.rejected('Bateria abaixo de 15%. Pré-condicionamento bloqueado para preservar autonomia.');
    }

    return null;
  }
}