import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../../../../core/cluster_colors.dart';

/// Traction power bar: regeneration to the left (green), consumption to the right.
/// Updated at 30 Hz without rebuilding widgets: the painter repaints from a notifier.
class PowerMeter extends ConsumerStatefulWidget {
  const PowerMeter({super.key});

  static const maxRegenKw = 80.0;
  static const maxPowerKw = 250.0;

  @override
  ConsumerState<PowerMeter> createState() => _PowerMeterState();
}

class _PowerMeterState extends ConsumerState<PowerMeter> {
  /// kW, positive = consumption (the COVESA signal is in W, positive = charging the battery).
  final _kw = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    final power = Vss.Vehicle.Powertrain.TractionBattery.CurrentPower;
    _kw.value = -((ref.read(vssValueProvider(power)) as double?) ?? 0) / 1000;
    ref.listenManual(vssValueProvider(power), (_, watts) => _kw.value = -((watts as double?) ?? 0) / 1000);
  }

  @override
  void dispose() {
    _kw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: CustomPaint(size: const Size(double.infinity, 10), painter: _PowerMeterPainter(_kw)),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder(
          valueListenable: _kw,
          builder: (context, kw, _) => Text(
            '${kw.round()} kW',
            style: const TextStyle(color: ClusterColors.textSecondary, fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ),
      ],
    );
  }
}

class _PowerMeterPainter extends CustomPainter {
  _PowerMeterPainter(this.kw) : super(repaint: kw);

  final ValueNotifier<double> kw;

  @override
  void paint(Canvas canvas, Size size) {
    final regenShare = PowerMeter.maxRegenKw / (PowerMeter.maxRegenKw + PowerMeter.maxPowerKw);
    final zeroX = size.width * regenShare;
    final radius = Radius.circular(size.height / 2);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, radius), Paint()..color = ClusterColors.surface);

    final value = kw.value;
    final rect = value >= 0
        ? Rect.fromLTRB(
            zeroX,
            0,
            zeroX + (size.width - zeroX) * (value / PowerMeter.maxPowerKw).clamp(0, 1),
            size.height,
          )
        : Rect.fromLTRB(zeroX - zeroX * (-value / PowerMeter.maxRegenKw).clamp(0, 1), 0, zeroX, size.height);
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        Paint()..color = value >= 0 ? ClusterColors.textPrimary : ClusterColors.regen,
      )
      ..drawRect(Rect.fromLTWH(zeroX - 1, -3, 2, size.height + 6), Paint()..color = ClusterColors.textSecondary);
  }

  @override
  bool shouldRepaint(_PowerMeterPainter oldDelegate) => oldDelegate.kw != kw;
}
