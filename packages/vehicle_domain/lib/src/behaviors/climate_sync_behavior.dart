import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/vehicle_behavior.dart';

/// SYNC: while it is on, the passenger and rear zones follow the driver temperature.
final class ClimateSyncBehavior implements VehicleBehavior {
  static const source = 'CLIMATE_SYNC';

  @override
  Set<VssSignal<Object>> get triggers => {
    VehicleGroups.hvacStations.first.temperature,
    Vss.Vehicle.Cabin.HVAC.IsSyncActive,
  };

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    if (!(after.read(Vss.Vehicle.Cabin.HVAC.IsSyncActive) ?? false)) return const [];

    final [driver, ...others] = VehicleGroups.hvacStations;
    final target = after.read(driver.temperature);
    if (target == null) return const [];
    return [
      for (final station in others)
        if (after.read(station.temperature) != target)
          VehicleCommand(signal: station.temperature, value: target, source: source),
    ];
  }
}
