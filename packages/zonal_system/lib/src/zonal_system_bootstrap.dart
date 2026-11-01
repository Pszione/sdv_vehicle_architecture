import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'controllers/door_zone_controller.dart';
import 'controllers/generic_zone_controller.dart';
import 'controllers/top_zonal_controller.dart';
import 'domain/vehicle_zone.dart';

part 'zonal_system_bootstrap.g.dart';

/// Liga uma ECU para cada zona. O app lê este provider no boot, antes do
/// primeiro comando: sem isso, os controladores não existiriam para escutar o barramento.
@Riverpod(keepAlive: true)
void zonalSystem(Ref ref) {
  ref
    ..watch(topZoneControllerProvider)
    ..watch(doorZoneControllerProvider(VehicleZone.west))
    ..watch(doorZoneControllerProvider(VehicleZone.east))
    ..watch(genericZoneControllerProvider(VehicleZone.south))
    ..watch(genericZoneControllerProvider(VehicleZone.central));
}
