import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'controllers/top_zonal_controller.dart';
import 'controllers/west_zonal_controller.dart';

part 'zonal_system_bootstrap.g.dart';

/// Liga todas as ECUs zonais. O app lê este provider no boot, antes do primeiro
/// comando: sem isso, os controladores não existiriam para escutar o barramento.
@Riverpod(keepAlive: true)
void zonalSystem(Ref ref) {
  ref
    ..watch(topZoneControllerProvider)
    ..watch(westZoneControllerProvider);
}
