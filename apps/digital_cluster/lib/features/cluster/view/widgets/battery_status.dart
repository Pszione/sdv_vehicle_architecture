import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/cluster_colors.dart';

/// State of charge and remaining range.
class BatteryStatus extends ConsumerWidget {
  const BatteryStatus({super.key, this.isLarge = false});

  final bool isLarge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soc = ref.watchSignal(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge);
    final rangeM = ref.watchSignal(Vss.Vehicle.Powertrain.Range);
    final scale = isLarge ? 1.6 : 1.0;

    return Column(
      crossAxisAlignment: isLarge ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.battery_std, size: 22 * scale, color: ClusterColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              soc == null ? '--%' : '${soc.round()}%',
              style: TextStyle(fontSize: 28 * scale, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        Text(
          rangeM == null ? '-- km' : '${(rangeM / 1000).round()} km',
          style: TextStyle(fontSize: 16 * scale, color: ClusterColors.textSecondary),
        ),
      ],
    );
  }
}
