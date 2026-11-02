import 'package:vehicle_domain/vehicle_domain.dart';

import 'vehicle_zone.dart';

/// Physical address of an actuator: zone + device.
final class ZonalRoute {
  const ZonalRoute(this.zone, this.deviceId);

  static const sunroof = ZonalRoute(VehicleZone.central, 'SUNROOF_ACTUATOR');
  static const hvac = ZonalRoute(VehicleZone.central, 'HVAC_MODULE');
  static const fallback = ZonalRoute(VehicleZone.central, 'DOMAIN_GATEWAY');

  final VehicleZone zone;
  final String deviceId;

  /// Route of [signal] in the E/E topology.
  ///
  /// VSS names doors and seats by role (`DriverSide`/`PassengerSide`); the
  /// physical side depends on [driverSide]: on a LHD car the driver side is
  /// the west zone, on a RHD car it is the east zone.
  static ZonalRoute of(VssSignal<Object> signal, DriverSide driverSide) {
    if (signal == Vss.Vehicle.Cabin.Sunroof.Position) return sunroof;
    if (_hvacSignals.contains(signal)) return hvac;

    final bodySide = _bodySideDevices[signal];
    if (bodySide == null) return fallback;

    final isWest = bodySide.isDriverSide == (driverSide == DriverSide.left);
    return ZonalRoute(isWest ? VehicleZone.west : VehicleZone.east, '${bodySide.device}_${isWest ? 'LEFT' : 'RIGHT'}');
  }

  static final Set<VssSignal<Object>> _hvacSignals = {
    for (final station in VehicleGroups.hvacStations) ...[
      station.temperature,
      station.fanSpeed,
      station.airDistribution,
    ],
    Vss.Vehicle.Cabin.HVAC.IsAirConditioningActive,
    Vss.Vehicle.Cabin.HVAC.IsRecirculationActive,
    Vss.Vehicle.Cabin.HVAC.IsFrontDefrosterActive,
    Vss.Vehicle.Cabin.HVAC.IsRearDefrosterActive,
    Vss.Vehicle.Cabin.HVAC.IsAutoActive,
    Vss.Vehicle.Cabin.HVAC.IsSyncActive,
    Vss.Vehicle.Cabin.HVAC.IsRearControlLocked,
    Vss.Vehicle.Chassis.SteeringWheel.HeatingCooling,
  };

  /// Body actuators by role: door locks and e-latches, door shades and seat comfort.
  static final Map<VssSignal<Object>, ({bool isDriverSide, String device})> _bodySideDevices = () {
    final door = Vss.Vehicle.Cabin.Door;
    final seat = Vss.Vehicle.Cabin.Seat;
    return <VssSignal<Object>, ({bool isDriverSide, String device})>{
      door.Row1.DriverSide.IsLocked: (isDriverSide: true, device: 'DOOR_FRONT'),
      door.Row1.PassengerSide.IsLocked: (isDriverSide: false, device: 'DOOR_FRONT'),
      door.Row2.DriverSide.IsLocked: (isDriverSide: true, device: 'DOOR_REAR'),
      door.Row2.PassengerSide.IsLocked: (isDriverSide: false, device: 'DOOR_REAR'),
      door.Row1.DriverSide.IsOpen: (isDriverSide: true, device: 'DOOR_FRONT'),
      door.Row1.PassengerSide.IsOpen: (isDriverSide: false, device: 'DOOR_FRONT'),
      door.Row2.DriverSide.IsOpen: (isDriverSide: true, device: 'DOOR_REAR'),
      door.Row2.PassengerSide.IsOpen: (isDriverSide: false, device: 'DOOR_REAR'),
      door.Row2.DriverSide.Shade.Position: (isDriverSide: true, device: 'DOOR_REAR'),
      door.Row2.PassengerSide.Shade.Position: (isDriverSide: false, device: 'DOOR_REAR'),
      seat.Row1.DriverSide.HeatingCooling: (isDriverSide: true, device: 'SEAT_FRONT'),
      seat.Row1.DriverSide.Massage.Level: (isDriverSide: true, device: 'SEAT_FRONT'),
      seat.Row1.DriverSide.Massage.TypeActive: (isDriverSide: true, device: 'SEAT_FRONT'),
      seat.Row1.PassengerSide.HeatingCooling: (isDriverSide: false, device: 'SEAT_FRONT'),
      seat.Row1.PassengerSide.Massage.Level: (isDriverSide: false, device: 'SEAT_FRONT'),
      seat.Row1.PassengerSide.Massage.TypeActive: (isDriverSide: false, device: 'SEAT_FRONT'),
      seat.Row2.DriverSide.HeatingCooling: (isDriverSide: true, device: 'SEAT_REAR'),
      seat.Row2.DriverSide.Massage.Level: (isDriverSide: true, device: 'SEAT_REAR'),
      seat.Row2.DriverSide.Massage.TypeActive: (isDriverSide: true, device: 'SEAT_REAR'),
      seat.Row2.PassengerSide.HeatingCooling: (isDriverSide: false, device: 'SEAT_REAR'),
      seat.Row2.PassengerSide.Massage.Level: (isDriverSide: false, device: 'SEAT_REAR'),
      seat.Row2.PassengerSide.Massage.TypeActive: (isDriverSide: false, device: 'SEAT_REAR'),
    };
  }();
}
