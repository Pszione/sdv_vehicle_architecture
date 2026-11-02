import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Range protection: with a nearly empty battery the blower is capped, to keep
/// the energy for driving.
final class ClimateRangeProtectionSafetyRule implements SafetyRule {
  ClimateRangeProtectionSafetyRule(this.target);

  static const minSoc = 10.0;
  static const maxFanPercent = 50;

  static List<ClimateRangeProtectionSafetyRule> all() => [
    for (final station in VehicleGroups.hvacStations) ClimateRangeProtectionSafetyRule(station.fanSpeed),
  ];

  @override
  final VssSignal<int> target;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if ((command.value as int) <= maxFanPercent) return null;

    final soc = signals.read(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge);
    if (soc != null && soc < minSoc) {
      return CommandResult.rejected(
        'Range protection: fan limited to $maxFanPercent% below ${minSoc.toInt()}% battery (current: ${soc.toInt()}%).',
      );
    }
    return null;
  }
}
