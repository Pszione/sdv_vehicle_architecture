import '../vss/vss.dart';
import '../vss/vss_signal.dart';

typedef DoorSignals = ({String label, VssSignal<bool> lock, VssSignal<bool> open});
typedef SeatSignals = ({
  String label,
  VssSignal<String> occupancy,
  VssSignal<bool> belted,
  VssSignal<int> heatingCooling,
});
typedef HvacStationSignals = ({
  String label,
  VssSignal<double> temperature,
  VssSignal<int> fanSpeed,
  VssSignal<String> airDistribution,
});

/// Groups of related signals used by rules, behaviors and the UI.
///
/// COVESA VSS names doors, seats and HVAC stations by role (`DriverSide`,
/// `PassengerSide`, `Driver`, `Passenger`), not by physical side, so the
/// driver is always `Row1.DriverSide` on LHD and RHD cars alike.
abstract final class VehicleGroups {
  static List<DoorSignals> get doors {
    final door = Vss.Vehicle.Cabin.Door;
    return [
      (label: 'Driver', lock: door.Row1.DriverSide.IsLocked, open: door.Row1.DriverSide.IsOpen),
      (label: 'Front passenger', lock: door.Row1.PassengerSide.IsLocked, open: door.Row1.PassengerSide.IsOpen),
      (label: 'Rear driver side', lock: door.Row2.DriverSide.IsLocked, open: door.Row2.DriverSide.IsOpen),
      (label: 'Rear passenger side', lock: door.Row2.PassengerSide.IsLocked, open: door.Row2.PassengerSide.IsOpen),
    ];
  }

  static List<SeatSignals> get seats {
    final seat = Vss.Vehicle.Cabin.Seat;
    return [
      (
        label: 'Driver',
        occupancy: seat.Row1.DriverSide.OccupancyStatus,
        belted: seat.Row1.DriverSide.IsBelted,
        heatingCooling: seat.Row1.DriverSide.HeatingCooling,
      ),
      (
        label: 'Front passenger',
        occupancy: seat.Row1.PassengerSide.OccupancyStatus,
        belted: seat.Row1.PassengerSide.IsBelted,
        heatingCooling: seat.Row1.PassengerSide.HeatingCooling,
      ),
      (
        label: 'Rear driver side',
        occupancy: seat.Row2.DriverSide.OccupancyStatus,
        belted: seat.Row2.DriverSide.IsBelted,
        heatingCooling: seat.Row2.DriverSide.HeatingCooling,
      ),
      (
        label: 'Rear passenger side',
        occupancy: seat.Row2.PassengerSide.OccupancyStatus,
        belted: seat.Row2.PassengerSide.IsBelted,
        heatingCooling: seat.Row2.PassengerSide.HeatingCooling,
      ),
    ];
  }

  static DoorSignals get driverDoor => doors.first;

  static SeatSignals get driverSeat => seats.first;

  /// HVAC stations: [0] driver, [1] front passenger, [2] rear driver side, [3] rear passenger side.
  static List<HvacStationSignals> get hvacStations {
    final station = Vss.Vehicle.Cabin.HVAC.Station;
    return [
      (
        label: 'Driver',
        temperature: station.Row1.Driver.Temperature,
        fanSpeed: station.Row1.Driver.FanSpeed,
        airDistribution: station.Row1.Driver.AirDistribution,
      ),
      (
        label: 'Passenger',
        temperature: station.Row1.Passenger.Temperature,
        fanSpeed: station.Row1.Passenger.FanSpeed,
        airDistribution: station.Row1.Passenger.AirDistribution,
      ),
      (
        label: 'Rear driver side',
        temperature: station.Row2.Driver.Temperature,
        fanSpeed: station.Row2.Driver.FanSpeed,
        airDistribution: station.Row2.Driver.AirDistribution,
      ),
      (
        label: 'Rear passenger side',
        temperature: station.Row2.Passenger.Temperature,
        fanSpeed: station.Row2.Passenger.FanSpeed,
        airDistribution: station.Row2.Passenger.AirDistribution,
      ),
    ];
  }

  static List<HvacStationSignals> get frontHvacStations => hvacStations.sublist(0, 2);

  /// The rear climate zone drives both rear stations together (3-zone climate).
  static List<HvacStationSignals> get rearHvacStations => hvacStations.sublist(2);
}
