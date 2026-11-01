import 'package:vehicle_domain/vehicle_domain.dart';

import 'vehicle_zone.dart';

/// Comando já aprovado pelo dispatcher e endereçado a um dispositivo de uma zona.
final class ZonalCommand {
  ZonalCommand({required this.targetZone, required this.deviceId, required this.command})
    : commandId = DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp = DateTime.now().millisecondsSinceEpoch;

  final VehicleZone targetZone;

  /// Ex: "DOOR_FRONT_LEFT", "SUNROOF_ACTUATOR".
  final String deviceId;
  final VehicleCommand<Object> command;
  final String commandId;
  final int timestamp;

  VssSignal<Object> get signal => command.signal;
}
