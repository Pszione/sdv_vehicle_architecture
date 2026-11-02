import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'climate_colors.dart';
import 'seat_climate_button.dart';

/// Top-down cabin: zones tinted by their temperature, airflow animated by fan
/// speed, and seat/steering heating controls over each seat. Mirrors for RHD cars.
class CabinView extends ConsumerStatefulWidget {
  const CabinView({super.key});

  @override
  ConsumerState<CabinView> createState() => _CabinViewState();
}

class _CabinViewState extends ConsumerState<CabinView> with SingleTickerProviderStateMixin {
  late final _airflow = AnimationController(vsync: this, duration: const Duration(seconds: 2));

  @override
  void dispose() {
    _airflow.dispose();
    super.dispose();
  }

  /// The animation only ticks while air is flowing, so an idle cabin costs no frames.
  void _syncAirflow(int fan) {
    if (fan > 0 && !_airflow.isAnimating) {
      _airflow.repeat();
    } else if (fan == 0 && _airflow.isAnimating) {
      _airflow.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRhd = ref.watch(activeVehicleProfileProvider.select((p) => p.driverSide == DriverSide.right));
    final stations = VehicleGroups.hvacStations;
    final temperatures = [for (final s in stations) ref.watchSignal(s.temperature) ?? 21.0];
    final fans = [for (final s in stations) ref.watchSignal(s.fanSpeed) ?? 0];
    final distribution = ref.watchSignal(stations.first.airDistribution) ?? AirDistribution.middle;
    final fan = fans.reduce(math.max);
    _syncAirflow(fan);

    final seats = VehicleGroups.seats;
    // VSS seats are named by role; place them physically (driver on the left for LHD).
    final driverX = isRhd ? 0.45 : -0.45;

    return AspectRatio(
      aspectRatio: 0.62,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _CabinPainter(
                  animation: _airflow,
                  frontLeftTemperature: temperatures[isRhd ? 1 : 0],
                  frontRightTemperature: temperatures[isRhd ? 0 : 1],
                  rearTemperature: temperatures[2],
                  fanPercent: fan,
                  distribution: distribution,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(driverX, -0.05),
            child: SeatClimateButton(seat: seats[0]),
          ),
          Align(
            alignment: Alignment(-driverX, -0.05),
            child: SeatClimateButton(seat: seats[1]),
          ),
          Align(
            alignment: Alignment(driverX, 0.55),
            child: SeatClimateButton(seat: seats[2]),
          ),
          Align(
            alignment: Alignment(-driverX, 0.55),
            child: SeatClimateButton(seat: seats[3]),
          ),
          Align(alignment: Alignment(driverX, -0.4), child: const SteeringWheelHeatButton()),
        ],
      ),
    );
  }
}

class _CabinPainter extends CustomPainter {
  _CabinPainter({
    required this.animation,
    required this.frontLeftTemperature,
    required this.frontRightTemperature,
    required this.rearTemperature,
    required this.fanPercent,
    required this.distribution,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final double frontLeftTemperature;
  final double frontRightTemperature;
  final double rearTemperature;
  final int fanPercent;
  final String distribution;

  static const _particlesPerFlow = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.02, size.width * 0.84, size.height * 0.96),
      Radius.circular(size.width * 0.28),
    );
    final cabin = body.outerRect.deflate(size.width * 0.06);
    final midX = cabin.center.dx;
    final rowSplitY = cabin.top + cabin.height * 0.58;

    // Zones tinted by requested temperature.
    void zone(Rect rect, double temperature) =>
        canvas.drawRect(rect, Paint()..color = ClimateColors.forTemperature(temperature).withValues(alpha: 0.10));
    canvas
      ..save()
      ..clipRRect(body);
    zone(Rect.fromLTRB(cabin.left, cabin.top, midX, rowSplitY), frontLeftTemperature);
    zone(Rect.fromLTRB(midX, cabin.top, cabin.right, rowSplitY), frontRightTemperature);
    zone(Rect.fromLTRB(cabin.left, rowSplitY, cabin.right, cabin.bottom), rearTemperature);
    canvas.restore();

    // Body outline, windshield and rear window.
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white24;
    canvas
      ..drawRRect(body, outline)
      ..drawArc(
        Rect.fromCenter(
          center: Offset(midX, cabin.top + cabin.height * 0.2),
          width: cabin.width,
          height: cabin.height * 0.18,
        ),
        math.pi * 1.1,
        math.pi * 0.8,
        false,
        outline,
      )
      ..drawLine(Offset(cabin.left, rowSplitY), Offset(cabin.right, rowSplitY), outline..color = Colors.white10);

    if (fanPercent == 0) return;

    // Airflow particles from the dashboard vents to the front seats, and from the console to the rear.
    final reach = switch (distribution) {
      AirDistribution.up => 0.22,
      AirDistribution.down => 0.42,
      _ => 0.32,
    };
    final dashY = cabin.top + cabin.height * 0.12;
    final particle = Paint();
    void flow(Offset from, Offset to, Color color) {
      final control = Offset((from.dx + to.dx) / 2, from.dy);
      for (var i = 0; i < _particlesPerFlow; i++) {
        final t = (i / _particlesPerFlow + animation.value * (0.5 + fanPercent / 100)) % 1.0;
        final point = Offset(
          math.pow(1 - t, 2) * from.dx + 2 * (1 - t) * t * control.dx + t * t * to.dx,
          math.pow(1 - t, 2) * from.dy + 2 * (1 - t) * t * control.dy + t * t * to.dy,
        );
        particle.color = color.withValues(alpha: (1 - t) * (0.3 + 0.6 * fanPercent / 100));
        canvas.drawCircle(point, 2 + 2 * fanPercent / 100, particle);
      }
    }

    for (final (vents, temperature) in [
      ([0.2, 0.35], frontLeftTemperature),
      ([0.65, 0.8], frontRightTemperature),
    ]) {
      for (final ventX in vents) {
        final from = Offset(cabin.left + cabin.width * ventX, dashY);
        flow(from, Offset(from.dx, dashY + cabin.height * reach), ClimateColors.forTemperature(temperature));
      }
    }
    final console = Offset(midX, rowSplitY - cabin.height * 0.04);
    for (final dx in [-0.25, 0.25]) {
      flow(
        console,
        Offset(midX + cabin.width * dx, rowSplitY + cabin.height * 0.18),
        ClimateColors.forTemperature(rearTemperature),
      );
    }
  }

  @override
  bool shouldRepaint(_CabinPainter old) =>
      old.frontLeftTemperature != frontLeftTemperature ||
      old.frontRightTemperature != frontRightTemperature ||
      old.rearTemperature != rearTemperature ||
      old.fanPercent != fanPercent ||
      old.distribution != distribution;
}
