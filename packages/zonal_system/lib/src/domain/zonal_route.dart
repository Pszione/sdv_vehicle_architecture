import 'package:vehicle_domain/vehicle_domain.dart';

import 'vehicle_zone.dart';

/// Endereço físico de um atuador: zona + dispositivo.
final class ZonalRoute {
  const ZonalRoute(this.zone, this.deviceId);

  static const fallback = ZonalRoute(VehicleZone.central, 'GENERIC_ACTUATOR');

  final VehicleZone zone;
  final String deviceId;

  /// Rota do sinal na topologia E/E. Sinais sem entrada vão para a ECU central.
  static ZonalRoute of(VssSignal<Object> signal) => _routingTable[signal] ?? fallback;

  static final Map<VssSignal<Object>, ZonalRoute> _routingTable = {
    Vss.Vehicle.Cabin.Door.Row1.Left.IsLocked: const ZonalRoute(VehicleZone.west, 'DOOR_FRONT_LEFT'),
    Vss.Vehicle.Cabin.Door.Row2.Left.IsLocked: const ZonalRoute(VehicleZone.west, 'DOOR_REAR_LEFT'),
    Vss.Vehicle.Cabin.Door.Row1.Right.IsLocked: const ZonalRoute(VehicleZone.east, 'DOOR_FRONT_RIGHT'),
    Vss.Vehicle.Cabin.Door.Row2.Right.IsLocked: const ZonalRoute(VehicleZone.east, 'DOOR_REAR_RIGHT'),
    Vss.Vehicle.Cabin.Sunroof.Position: const ZonalRoute(VehicleZone.top, 'SUNROOF_ACTUATOR'),
    Vss.Vehicle.Chassis.Suspension.Height: const ZonalRoute(VehicleZone.south, 'AIR_SUSPENSION_MODULE'),
    Vss.Vehicle.Chassis.Suspension.DampingMode: const ZonalRoute(VehicleZone.south, 'AIR_SUSPENSION_MODULE'),
  };
}
