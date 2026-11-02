import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'controllers/central_zone_controller.dart';
import 'controllers/east_zone_controller.dart';
import 'controllers/west_zone_controller.dart';
import 'power/vehicle_mode_manager.dart';
import 'power/zone_network_management.dart';

part 'zonal_system_bootstrap.g.dart';

/// Starts one ECU per zone, the vehicle mode manager and the network management.
/// The app reads this provider at boot, before the first command: otherwise no
/// controller would exist to listen to the bus.
@Riverpod(keepAlive: true)
void zonalSystem(Ref ref) {
  ref
    ..watch(westZoneControllerProvider)
    ..watch(eastZoneControllerProvider)
    ..watch(centralZoneControllerProvider)
    ..watch(vehicleModeManagerProvider)
    // Listen, not watch: the NM state changes often and must not rebuild the bootstrap.
    ..listen(zoneNetworkManagementProvider, (_, _) {});
}
