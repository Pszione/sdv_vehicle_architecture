import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'controllers/central_zone_controller.dart';
import 'controllers/east_zone_controller.dart';
import 'controllers/west_zone_controller.dart';

part 'zonal_system_bootstrap.g.dart';

/// Starts one ECU per zone. The app reads this provider at boot, before the
/// first command: otherwise no controller would exist to listen to the bus.
@Riverpod(keepAlive: true)
void zonalSystem(Ref ref) {
  ref
    ..watch(westZoneControllerProvider)
    ..watch(eastZoneControllerProvider)
    ..watch(centralZoneControllerProvider);
}
