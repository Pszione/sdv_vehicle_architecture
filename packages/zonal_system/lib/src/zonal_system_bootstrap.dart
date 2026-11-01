import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'controllers/door_zone_controller.dart';
import 'controllers/generic_zone_controller.dart';
import 'controllers/top_zonal_controller.dart';
import 'domain/vehicle_zone.dart';

part 'zonal_system_bootstrap.g.dart';

/// Starts one ECU per zone. The app reads this provider at boot, before the
/// first command: otherwise no controller would exist to listen to the bus.
@Riverpod(keepAlive: true)
void zonalSystem(Ref ref) {
  ref
    ..watch(topZoneControllerProvider)
    ..watch(doorZoneControllerProvider(VehicleZone.west))
    ..watch(doorZoneControllerProvider(VehicleZone.east))
    ..watch(genericZoneControllerProvider(VehicleZone.south))
    ..watch(genericZoneControllerProvider(VehicleZone.central));
}
