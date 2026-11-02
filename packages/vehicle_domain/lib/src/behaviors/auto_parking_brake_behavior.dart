import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Electric parking brake follows PARK: applied when PARK engages, released when leaving it.
final class AutoParkingBrakeBehavior implements VehicleBehavior {
  static const source = 'AUTO_EPB';

  @override
  Set<VssSignal<Object>> get triggers => {Vss.Vehicle.Powertrain.Transmission.SelectedGear};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) {
    final gear = Vss.Vehicle.Powertrain.Transmission.SelectedGear;
    final isParked = after.read(gear) == Gear.park;
    if ((before.read(gear) == Gear.park) == isParked) return const [];
    return [VehicleCommand(signal: Vss.Vehicle.Chassis.ParkingBrake.IsEngaged, value: isParked, source: source)];
  }
}
