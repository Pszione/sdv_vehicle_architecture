import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../actuators/dumb_door_actuator.dart';
import '../bus/zonal_command_bus.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_command.dart';

part 'door_zone_controller.g.dart';

/// ECU de uma zona lateral (west/east): travas das portas daquele lado.
@Riverpod(keepAlive: true)
class DoorZoneController extends _$DoorZoneController {
  static const _doorIds = {
    VehicleZone.west: ['DOOR_FRONT_LEFT', 'DOOR_REAR_LEFT'],
    VehicleZone.east: ['DOOR_FRONT_RIGHT', 'DOOR_REAR_RIGHT'],
  };

  var _doors = <String, DumbDoorActuator>{};

  @override
  void build(VehicleZone zone) {
    _doors = {for (final id in _doorIds[zone] ?? const <String>[]) id: DumbDoorActuator(id)};
    final commands = ref.watch(zonalCommandBusProvider).commandsFor(zone).listen(_process);
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
