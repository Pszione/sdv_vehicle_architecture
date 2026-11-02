import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Rear climate lock (child lock for climate): while it is on, the rear
/// passenger panel cannot change the rear zone. Front controls still can.
final class RearClimateLockSafetyRule implements SafetyRule {
  RearClimateLockSafetyRule(this.target);

  /// Source used by the rear passenger climate panel.
  static const rearPanelSource = 'REAR_PANEL';

  static List<RearClimateLockSafetyRule> all() => [
    for (final station in VehicleGroups.rearHvacStations)
      for (final signal in <VssSignal<Object>>[station.temperature, station.fanSpeed, station.airDistribution])
        RearClimateLockSafetyRule(signal),
  ];

  @override
  final VssSignal<Object> target;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Cabin.HVAC.IsRearControlLocked};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.source != rearPanelSource) return null;
    if (signals.read(Vss.Vehicle.Cabin.HVAC.IsRearControlLocked) ?? false) {
      return const CommandResult.rejected('Rear climate controls are locked from the front.');
    }
    return null;
  }
}
