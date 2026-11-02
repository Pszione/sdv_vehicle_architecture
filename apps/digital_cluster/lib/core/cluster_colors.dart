import 'package:flutter/material.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Cluster palette: near-black, white type, one accent; telltale colors per ISO 2575.
abstract final class ClusterColors {
  static const background = Color(0xFF050607);
  static const surface = Color(0xFF111316);
  static const road = Color(0xFF1A1D22);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0x99FFFFFF);
  static const textMuted = Color(0x40FFFFFF);
  static const accent = Color(0xFF3D9BFF);
  static const regen = Color(0xFF34C759);
  static const ready = Color(0xFF34C759);

  static Color telltale(TelltaleColor color) => switch (color) {
    TelltaleColor.red => const Color(0xFFFF453A),
    TelltaleColor.amber => const Color(0xFFFFB020),
    TelltaleColor.green => const Color(0xFF34C759),
    TelltaleColor.blue => const Color(0xFF3D7BFF),
  };

  static Color severity(DriverMessageSeverity severity) => switch (severity) {
    DriverMessageSeverity.warning => const Color(0xFFFFB020),
    DriverMessageSeverity.fault => const Color(0xFFFF453A),
    DriverMessageSeverity.info => accent,
  };
}
