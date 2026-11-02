import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Current power mode (OFF, ACC, ON, READY...). Hidden when the vehicle reports no 12 V state.
class PowerModeChip extends ConsumerWidget {
  const PowerModeChip({super.key});

  static Color colorOf(PowerMode mode) => switch (mode) {
    PowerMode.ready => Colors.greenAccent,
    PowerMode.charging => Colors.lightBlueAccent,
    PowerMode.softwareUpdate => Colors.orangeAccent,
    PowerMode.on || PowerMode.accessory => Colors.white70,
    PowerMode.off || PowerMode.sleep => Colors.white38,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(powerModeProvider);
    if (mode == null) return const SizedBox.shrink();
    final color = colorOf(mode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.power_settings_new, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            mode.label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
