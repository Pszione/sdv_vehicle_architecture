import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/cluster_colors.dart';
import '../../../../core/interpolated_value.dart';

/// Live road view (Tesla/Rivian style): the ego car from behind, the lanes curving ahead,
/// the lead vehicle at its real distance.
///
/// Rendering budget: the camera/radar signals arrive at 30 Hz and are listened to (never
/// watched), interpolated, and painted at the display rate by one [CustomPainter] that
/// repaints from a frame notifier: no widget rebuild per frame. The ticker only runs while
/// something moves (speed > 0 or an interpolation in progress).
class AdasView extends ConsumerStatefulWidget {
  const AdasView({super.key});

  @override
  ConsumerState<AdasView> createState() => _AdasViewState();
}

class _AdasViewState extends ConsumerState<AdasView> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_onTick);
  final _scene = _RoadScene();
  final _frame = ValueNotifier(0);
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    final adas = Vss.Vehicle.ADAS;
    _bind(Vss.Vehicle.Speed, (v) => _scene.speedKmh.target = (v as double?) ?? 0);
    _bind(adas.LaneKeepingAssist.LateralOffset, (v) => _scene.lateralOffset.target = (v as double?) ?? 0);
    _bind(adas.LaneKeepingAssist.Curvature, (v) => _scene.curvature.target = (v as double?) ?? 0);
    _bind(adas.ObstacleDetection.Front.Center.Distance, (v) => _scene.leadDistance.target = (v as double?) ?? 250);
    _bind(adas.ObstacleDetection.Front.Center.IsWarning, (v) => _scene.isCollisionWarning = v == true);
    _bind(adas.LaneDepartureDetection.IsWarning, (v) => _scene.isLaneDeparture = v == true);
    _bind(adas.LaneKeepingAssist.IsEnabled, (v) => _scene.isLaneKeeping = v == true);
    _bind(adas.CruiseControl.IsActive, (v) => _scene.isCruising = v == true);
    _bind(adas.CruiseControl.AdaptiveIntervalSet, (v) => _scene.gapBars = ((v as double?) ?? 2).round());
  }

  /// Listens to [signal] without rebuilding, applies it to the scene and wakes the ticker.
  void _bind(VssSignal<Object> signal, void Function(Object? value) apply) {
    apply(ref.read(vssValueProvider(signal)));
    _scene.snapToTargets();
    ref.listenManual(vssValueProvider(signal), (_, value) {
      apply(value);
      _wake();
    });
  }

  void _wake() {
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
    _frame.value++;
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _lastTick;
    _lastTick = elapsed;
    final isMoving = _scene.advance(dt);
    _frame.value++;
    if (!isMoving) _ticker.stop();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraStatus = ref.watchSignalStatus(Vss.Vehicle.ADAS.LaneKeepingAssist.LateralOffset);
    final radarStatus = ref.watchSignalStatus(Vss.Vehicle.ADAS.ObstacleDetection.Front.Center.Distance);
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RoadPainter(
                _scene,
                _frame,
                showsLanes: cameraStatus == SignalStatus.valid,
                showsLead: radarStatus == SignalStatus.valid,
              ),
            ),
          ),
        ),
        if (cameraStatus != SignalStatus.valid || radarStatus != SignalStatus.valid)
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                cameraStatus != SignalStatus.valid ? 'Camera unavailable' : 'Radar unavailable',
                style: const TextStyle(color: ClusterColors.textSecondary),
              ),
            ),
          ),
      ],
    );
  }
}

/// Everything the painter draws, interpolated to the display rate.
final class _RoadScene {
  final speedKmh = InterpolatedValue(0);
  final lateralOffset = InterpolatedValue(0);
  final curvature = InterpolatedValue(0);
  final leadDistance = InterpolatedValue(250);
  bool isCollisionWarning = false;
  bool isLaneDeparture = false;
  bool isLaneKeeping = false;
  bool isCruising = false;
  int gapBars = 2;

  /// Distance travelled, for the lane dashes scrolling at the real speed.
  double odometerM = 0;

  List<InterpolatedValue> get _values => [speedKmh, lateralOffset, curvature, leadDistance];

  void snapToTargets() {
    for (final value in _values) {
      value.advance(const Duration(days: 1));
    }
  }

  /// Returns whether anything still moves.
  bool advance(Duration elapsed) {
    var changed = false;
    for (final value in _values) {
      changed |= value.advance(elapsed);
    }
    final metersPerSecond = speedKmh.value / 3.6;
    odometerM += metersPerSecond * elapsed.inMicroseconds / 1e6;
    return changed || metersPerSecond > 0.05;
  }
}

class _RoadPainter extends CustomPainter {
  _RoadPainter(this.scene, Listenable frame, {required this.showsLanes, required this.showsLead})
    : super(repaint: frame);

  final _RoadScene scene;

  /// Lanes and the lead car are hidden when their sensor signal is not valid.
  final bool showsLanes;
  final bool showsLead;

  static const _laneWidth = 3.6;
  static const _viewDistance = 120.0;
  static const _dashLength = 3.0;
  static const _dashPeriod = 9.0;

  /// Perspective: z = 0 m at the bottom, the horizon at infinity.
  static const _zRef = 20.0;

  late Size _size;

  double get _horizonY => _size.height * 0.18;
  double get _bottomY => _size.height * 0.98;
  double get _pixelsPerMeter => _size.width / 12;

  double _scale(double z) => _zRef / (z + _zRef);

  /// Screen position of a point [x] meters right of the lane center, [z] meters ahead.
  Offset _project(double x, double z) {
    final roadX = x - scene.lateralOffset.value + 0.5 * scene.curvature.value * z * z;
    final scale = _scale(z);
    return Offset(_size.width / 2 + roadX * _pixelsPerMeter * scale, _horizonY + (_bottomY - _horizonY) * scale);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _size = size;
    canvas.clipRect(Offset.zero & size);
    _paintRoad(canvas);
    if (showsLanes) _paintLanes(canvas);
    if (showsLead && scene.leadDistance.value < _viewDistance) _paintLead(canvas);
    _paintEgo(canvas);
  }

  void _paintRoad(Canvas canvas) {
    final edge = _laneWidth * 1.5 + 0.8;
    final path = _strip(-edge, edge);
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ClusterColors.background, ClusterColors.road],
        ).createShader(Offset.zero & _size),
    );
    if (scene.isLaneKeeping) {
      canvas.drawPath(
        _strip(-_laneWidth / 2, _laneWidth / 2),
        Paint()..color = ClusterColors.accent.withValues(alpha: 0.16),
      );
    }
  }

  /// Road strip between two lateral positions, from z = 0 to the view distance.
  Path _strip(double left, double right) {
    final path = Path()..moveTo(_project(left, 0).dx, _project(left, 0).dy);
    for (var z = 0.0; z <= _viewDistance; z += 4) {
      final p = _project(left, z);
      path.lineTo(p.dx, p.dy);
    }
    for (var z = _viewDistance; z >= 0; z -= 4) {
      final p = _project(right, z);
      path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  void _paintLanes(Canvas canvas) {
    final departureSide = scene.lateralOffset.value.sign;
    for (final x in [-1.5 * _laneWidth, -_laneWidth / 2, _laneWidth / 2, 1.5 * _laneWidth]) {
      final isEgoLane = x.abs() < _laneWidth;
      final isDeparting = scene.isLaneDeparture && isEgoLane && x.sign == departureSide;
      final paint = Paint()
        ..color = isDeparting
            ? ClusterColors.telltale(TelltaleColor.red)
            : (isEgoLane && scene.isLaneKeeping ? ClusterColors.accent : Colors.white.withValues(alpha: 0.55))
        ..strokeCap = StrokeCap.round;
      if (isEgoLane) {
        _paintDashed(canvas, x, paint);
      } else {
        _paintSolid(canvas, x, paint);
      }
    }
  }

  void _paintSolid(Canvas canvas, double x, Paint paint) {
    final start = _project(x, 0);
    final path = Path()..moveTo(start.dx, start.dy);
    for (var z = 2.0; z <= _viewDistance; z += 2) {
      final point = _project(x, z);
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _paintDashed(Canvas canvas, double x, Paint paint) {
    final phase = scene.odometerM % _dashPeriod;
    for (var start = -phase; start < _viewDistance; start += _dashPeriod) {
      _segment(canvas, x, math.max(0, start), start + _dashLength, paint);
    }
  }

  void _segment(Canvas canvas, double x, double z1, double z2, Paint paint) {
    if (z2 <= 0) return;
    final from = _project(x, z1);
    final to = _project(x, z2);
    canvas.drawLine(from, to, paint..strokeWidth = math.max(1, 0.15 * _pixelsPerMeter * _scale(z1)));
  }

  void _paintLead(Canvas canvas) {
    final z = scene.leadDistance.value;
    final color = scene.isCollisionWarning ? ClusterColors.telltale(TelltaleColor.red) : const Color(0xFFB8BEC6);
    _paintCar(canvas, z, color);

    if (scene.isCruising) {
      // Gap bars between the ego car and the lead car.
      for (var bar = 1; bar <= scene.gapBars; bar++) {
        final barZ = z * bar / (scene.gapBars + 1);
        final left = _project(-0.9, barZ);
        final right = _project(0.9, barZ);
        canvas.drawLine(
          left,
          right,
          Paint()
            ..color = ClusterColors.accent.withValues(alpha: 0.7)
            ..strokeWidth = math.max(1.5, 0.25 * _pixelsPerMeter * _scale(barZ)),
        );
      }
    }
  }

  void _paintEgo(Canvas canvas) => _paintCar(canvas, 2.5, Colors.white, isEgo: true);

  /// A car seen from behind: body, roof/rear window and tail lights, scaled by distance.
  void _paintCar(Canvas canvas, double z, Color color, {bool isEgo = false}) {
    final center = _project(isEgo ? scene.lateralOffset.value : 0, z);
    final scale = _scale(z);
    final width = 1.95 * _pixelsPerMeter * scale;
    final height = width * 0.62;
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center.translate(0, -height / 2), width: width, height: height),
      Radius.circular(width * 0.14),
    );
    canvas
      ..drawRRect(body.shift(Offset(0, height * 0.08)), Paint()..color = Colors.black.withValues(alpha: 0.5))
      ..drawRRect(body, Paint()..color = color.withValues(alpha: isEgo ? 0.95 : 0.85));
    final window = Rect.fromCenter(
      center: center.translate(0, -height * 0.72),
      width: width * 0.62,
      height: height * 0.3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(window, Radius.circular(width * 0.06)),
      Paint()..color = ClusterColors.background.withValues(alpha: 0.75),
    );
    final lightPaint = Paint()..color = const Color(0xFFFF3B30);
    for (final side in [-1, 1]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center.translate(side * width * 0.36, -height * 0.35),
            width: width * 0.18,
            height: height * 0.08,
          ),
          Radius.circular(height * 0.04),
        ),
        lightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RoadPainter oldDelegate) =>
      oldDelegate.scene != scene || oldDelegate.showsLanes != showsLanes || oldDelegate.showsLead != showsLead;
}
