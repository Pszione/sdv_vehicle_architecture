import 'package:vehicle_domain/vehicle_domain.dart';

import '../actuators/dumb_door_actuator.dart';
import '../domain/zonal_command.dart';

/// Logic shared by the west and east body ECUs: door lock actuators plus
/// door e-latches, seat comfort and window shades, which are confirmed as commanded.
final class BodySideEcu {
  static final _lockSignals = {for (final door in VehicleGroups.doors) door.lock};

  final _doorLocks = <String, DumbDoorActuator>{};

  void handle(ZonalCommand command, VssBroker broker) {
    final value = command.command.value;

    if (_lockSignals.contains(command.signal) && value is bool) {
      final door = _doorLocks.putIfAbsent(command.deviceId, () => DumbDoorActuator(command.deviceId))
        ..applyLockSignal(value);
      // Confirms the physical state as telemetry.
      broker.publish(command.signal as VssSignal<bool>, door.isLocked);
      return;
    }
    broker.publish(command.signal, value);
  }
}
