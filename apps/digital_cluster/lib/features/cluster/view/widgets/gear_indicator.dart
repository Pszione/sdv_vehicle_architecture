import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/cluster_colors.dart';

/// Vertical P R N D, the selected gear lit (Tesla style).
class GearIndicator extends ConsumerWidget {
  const GearIndicator({super.key});

  static const _gears = [Gear.park, Gear.reverse, Gear.neutral, Gear.drive];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watchSignal(Vss.Vehicle.Powertrain.Transmission.SelectedGear);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final gear in _gears)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              Gear.label(gear)[0],
              style: TextStyle(
                fontSize: 26,
                fontWeight: gear == selected ? FontWeight.w800 : FontWeight.w400,
                color: gear == selected ? ClusterColors.textPrimary : ClusterColors.textMuted,
              ),
            ),
          ),
      ],
    );
  }
}
