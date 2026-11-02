import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Max front defrost clears fog fast: A/C on (dries the air), fresh air
/// (recirculation off), airflow to the windshield and at least 70% fan in front.
final class MaxDefrostBehavior implements VehicleBehavior {
  static const source = 'DEFROST';
  static const minFanPercent = 70;

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Cabin.HVAC.IsFrontDefrosterActive};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    final hvac = Vss.Vehicle.Cabin.HVAC;
    if (!after.becameEqual(before, hvac.IsFrontDefrosterActive, true)) return const [];

    return [
      if (after.read(hvac.IsAirConditioningActive) != true)
        VehicleCommand(signal: hvac.IsAirConditioningActive, value: true, source: source),
      if (after.read(hvac.IsRecirculationActive) != false)
        VehicleCommand(signal: hvac.IsRecirculationActive, value: false, source: source),
      for (final station in VehicleGroups.frontHvacStations) ...[
        if (after.read(station.airDistribution) != AirDistribution.up)
          VehicleCommand(signal: station.airDistribution, value: AirDistribution.up, source: source),
        if ((after.read(station.fanSpeed) ?? 0) < minFanPercent)
          VehicleCommand(signal: station.fanSpeed, value: minFanPercent, source: source),
      ],
    ];
  }
}
