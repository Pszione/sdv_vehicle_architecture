import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/cluster_colors.dart';

/// Big speed, the speed limit sign and the cruise control set speed and gap.
/// An unreliable speed (lost, frozen, corrupted) shows `--`, never a stale number.
class SpeedReadout extends StatelessWidget {
  const SpeedReadout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SpeedValue(),
        Text('km/h', style: TextStyle(color: ClusterColors.textSecondary, fontSize: 20)),
        SizedBox(height: 20),
        Row(children: [_SpeedLimitSign(), SizedBox(width: 12), _CruiseChip()]),
      ],
    );
  }
}

class _SpeedValue extends ConsumerWidget {
  const _SpeedValue();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watchSignal(Vss.Vehicle.Speed);
    final isValid = ref.watchSignalStatus(Vss.Vehicle.Speed) == SignalStatus.valid;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        isValid && speed != null ? '${speed.round()}' : '--',
        style: const TextStyle(
          fontSize: 120,
          fontWeight: FontWeight.w300,
          height: 1,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _SpeedLimitSign extends ConsumerWidget {
  const _SpeedLimitSign();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limit = ref.watchSignal(Vss.Vehicle.ADAS.TrafficSignRecognition.SpeedLimit) ?? 0;
    if (limit == 0) return const SizedBox.shrink();

    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE0262B), width: 5),
      ),
      child: Text(
        '$limit',
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
      ),
    );
  }
}

class _CruiseChip extends ConsumerWidget {
  const _CruiseChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cruise = Vss.Vehicle.ADAS.CruiseControl;
    if (!(ref.watchSignal(cruise.IsActive) ?? false)) return const SizedBox.shrink();
    final setSpeed = ref.watchSignal(cruise.SpeedSet) ?? 0;
    final gapBars = (ref.watchSignal(cruise.AdaptiveIntervalSet) ?? 2).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ClusterColors.accent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.speed, size: 18, color: ClusterColors.accent),
          const SizedBox(width: 6),
          Text('${setSpeed.round()}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(width: 10),
          for (var bar = 1; bar <= 3; bar++)
            Container(
              width: 4,
              height: 6.0 + bar * 4,
              margin: const EdgeInsets.only(left: 2),
              color: bar <= gapBars ? ClusterColors.accent : ClusterColors.textMuted,
            ),
        ],
      ),
    );
  }
}
