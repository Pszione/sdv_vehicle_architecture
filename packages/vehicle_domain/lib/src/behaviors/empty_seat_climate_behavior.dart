import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/vehicle_behavior.dart';

/// Turns seat heating/ventilation off when the seat becomes empty, so energy is
/// not wasted on an empty seat.
final class EmptySeatClimateBehavior implements VehicleBehavior {
  static const source = 'SEAT_CLIMATE';

  @override
  Set<VssSignal<Object>> get triggers => {for (final seat in VehicleGroups.seats) seat.occupancy};

  @override
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after) => [
    for (final seat in VehicleGroups.seats)
      if (after.becameEqual(before, seat.occupancy, SeatOccupancy.empty) && (after.read(seat.heatingCooling) ?? 0) != 0)
        VehicleCommand(signal: seat.heatingCooling, value: 0, source: source),
  ];
}
