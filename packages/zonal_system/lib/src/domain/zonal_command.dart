class ZonalCommand {
  final String targetZone;  // Ex: "ZONE_WEST", "ZONE_EAST"
  final String deviceId;    // Ex: "DOOR_FRONT_LEFT", "SUNROOF"
  final String vssPath;     // Ex: "Vehicle.Cabin.Door.Row1.Left.IsLocked"
  final dynamic actionPayload;
  final String commandId;
  final int timestamp;

  ZonalCommand({
    required this.targetZone,
    required this.deviceId,
    required this.vssPath,
    required this.actionPayload,
  })  : commandId = DateTime.now().microsecondsSinceEpoch.toString(),
        timestamp = DateTime.now().millisecondsSinceEpoch;
}