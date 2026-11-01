import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../bus/zonal_command_bus.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_command.dart';

part 'generic_zone_controller.g.dart';

/// Generic ECU for actuators without a physical model yet (HVAC, seats,
/// suspension...): confirms the commanded value as telemetry, without latency.
///
/// When an actuator gets its own model (like the sunroof), move it to a
/// dedicated controller and out of this zone's routes.
@Riverpod(keepAlive: true)
class GenericZoneController extends _$GenericZoneController {
  @override
  void build(VehicleZone zone) {
    final commands = ref.watch(zonalCommandBusProvider).commandsFor(zone).listen(_process);
    ref.onDispose(commands.cancel);
  }

  void _process(ZonalCommand command) =>
      ref.read(vssBrokerProvider.notifier).publish(command.signal, command.command.value);
}
