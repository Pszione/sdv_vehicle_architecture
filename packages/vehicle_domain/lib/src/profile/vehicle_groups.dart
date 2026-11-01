import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'vehicle_profile.dart';

typedef DoorSignals = ({String label, VssSignal<bool> lock, VssSignal<bool> ajar});
typedef SeatSignals = ({String label, VssSignal<bool> occupied, VssSignal<bool> belted});

/// Groups of related signals used by rules and behaviors (all doors, all seats,
/// the driver's door/seat for a given LHD/RHD layout).
abstract final class VehicleGroups {
  static List<DoorSignals> get doors {
    final door = Vss.Vehicle.Cabin.Door;
    return [
      (label: 'Front left', lock: door.Row1.Left.IsLocked, ajar: door.Row1.Left.IsAjar),
      (label: 'Front right', lock: door.Row1.Right.IsLocked, ajar: door.Row1.Right.IsAjar),
      (label: 'Rear left', lock: door.Row2.Left.IsLocked, ajar: door.Row2.Left.IsAjar),
      (label: 'Rear right', lock: door.Row2.Right.IsLocked, ajar: door.Row2.Right.IsAjar),
    ];
  }

  static List<SeatSignals> get seats {
    final seat = Vss.Vehicle.Seat;
    return [
      (label: 'Front left', occupied: seat.Row1.Left.IsOccupied, belted: seat.Row1.Left.IsBelted),
      (label: 'Front right', occupied: seat.Row1.Right.IsOccupied, belted: seat.Row1.Right.IsBelted),
      (label: 'Rear left', occupied: seat.Row2.Left.IsOccupied, belted: seat.Row2.Left.IsBelted),
      (label: 'Rear right', occupied: seat.Row2.Right.IsOccupied, belted: seat.Row2.Right.IsBelted),
    ];
  }

  static DoorSignals driverDoor(DriverSide side) => side == DriverSide.left ? doors[0] : doors[1];

  static SeatSignals driverSeat(DriverSide side) => side == DriverSide.left ? seats[0] : seats[1];
}
