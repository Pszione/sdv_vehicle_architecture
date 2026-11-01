import 'package:vehicle_domain/vehicle_domain.dart';

import 'vehicle_zone.dart';

/// Command already approved by the dispatcher, addressed to a device in a zone.
final class ZonalCommand {
  ZonalCommand({required this.targetZone, required this.deviceId, required this.command})
    : commandId = DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp = DateTime.now().millisecondsSinceEpoch;

  final VehicleZone targetZone;

  /// E.g. "DOOR_FRONT_LEFT", "SUNROOF_ACTUATOR".
  final String deviceId;
  final VehicleCommand<Object> command;
  final String commandId;
  final int timestamp;

  VssSignal<Object> get signal => command.signal;
}
