
class VehicleProfile {
  final String id;
  final String trimName;
  final Set<String> supportedCapabilities;

  VehicleProfile({
    required this.id,
    required this.trimName,
    required this.supportedCapabilities,
  });
}