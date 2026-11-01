import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../actuators/dumb_door_actuator.dart';
import '../bus/zonal_command_bus.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_command.dart';

part 'west_zonal_controller.g.dart';

/// ECU da zona oeste: travas das portas do lado esquerdo.
@Riverpod(keepAlive: true)
class WestZoneController extends _$WestZoneController {
  final _doors = {
    for (final id in ['DOOR_FRONT_LEFT', 'DOOR_REAR_LEFT']) id: DumbDoorActuator(id),
  };

  @override
  void build() {
    final commands = ref.watch(zonalCommandBusProvider).commandsFor(VehicleZone.west).listen(_process);
    ref.onDispose(commands.cancel);
  }

  void _process(ZonalCommand command) {
    final door = _doors[command.deviceId];
    final lock = command.command.value;
    if (door == null || lock is! bool) return;

    door.applyLockSignal(lock);

    // Confirma o estado físico como telemetria.
    ref.read(vssBrokerProvider.notifier).publish(command.signal as VssSignal<bool>, door.isLocked);
  }
}
