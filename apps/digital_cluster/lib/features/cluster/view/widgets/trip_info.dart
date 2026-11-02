import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/cluster_colors.dart';

/// Odometer, outside temperature and the power mode.
class TripInfo extends ConsumerWidget {
  const TripInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final odometerM = ref.watchSignal(Vss.Vehicle.TraveledDistance);
    final outside = ref.watchSignal(Vss.Vehicle.Exterior.AirTemperature);
    const style = TextStyle(color: ClusterColors.textSecondary, fontFeatures: [FontFeature.tabularFigures()]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const PowerModeChip(),
        const SizedBox(height: 8),
        if (outside != null) Text('${outside.round()} °C outside', style: style),
        if (odometerM != null) Text('ODO ${_thousands(odometerM ~/ 1000)} km', style: style),
      ],
    );
  }

  static String _thousands(int value) => value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ' ');
}
