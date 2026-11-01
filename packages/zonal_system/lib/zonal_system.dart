/// Zonal architecture simulation: bus, routing, zonal ECUs and actuators.
library;

export 'src/actuators/dumb_door_actuator.dart';
export 'src/actuators/dumb_sunroof_actuator.dart';
export 'src/bus/zonal_command_bus.dart';
export 'src/bus/zonal_command_sink.dart';
export 'src/controllers/top_zonal_controller.dart';
export 'src/controllers/door_zone_controller.dart';
export 'src/controllers/generic_zone_controller.dart';
export 'src/domain/actuator_state.dart';
export 'src/domain/vehicle_zone.dart';
export 'src/domain/zonal_command.dart';
export 'src/domain/zonal_route.dart';
export 'src/zonal_system_bootstrap.dart';
