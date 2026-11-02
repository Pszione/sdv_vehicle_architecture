import 'package:flutter/material.dart';

/// Shared climate palette: blue for cooling, orange for heating.
abstract final class ClimateColors {
  static const cool = Colors.lightBlueAccent;
  static const heat = Colors.deepOrangeAccent;

  /// Color of a requested temperature, so a zone reads "cool" or "warm" at a glance.
  static Color forTemperature(double celsius) => switch (celsius) {
    <= 19 => cool,
    >= 24 => heat,
    _ => Colors.white,
  };
}
