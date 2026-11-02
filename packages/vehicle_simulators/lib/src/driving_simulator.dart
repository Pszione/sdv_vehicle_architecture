import 'dart:async';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import 'telemetry_simulator.dart';

part 'driving_simulator.g.dart';

/// Car ahead in a [DriveProfile].
final class LeadVehicle {
  const LeadVehicle({
    required this.initialDistanceM,
    required this.speedKmh,
    this.brakesAfter,
    this.brakedSpeedKmh = 20,
  });

  final double initialDistanceM;
  final double speedKmh;

  /// When set, the lead car brakes hard after this time, down to [brakedSpeedKmh].
  final Duration? brakesAfter;
  final double brakedSpeedKmh;
}

/// A drive played by the [DrivingSimulator].
final class DriveProfile {
  const DriveProfile({
    required this.name,
    required this.targetSpeedKmh,
    this.speedLimitKmh = 0,
    this.lead,
    this.laneDriftM = 0.15,
    this.curvature = 0.0015,
  });

  final String name;

  /// Speed the "driver" aims for without cruise control.
  final double targetSpeedKmh;
  final int speedLimitKmh;
  final LeadVehicle? lead;

  /// Amplitude of the lateral drift in the lane (reduced while lane keeping is on).
  final double laneDriftM;

  /// Peak lane curvature (1/m).
  final double curvature;

  static const city = DriveProfile(
    name: 'City',
    targetSpeedKmh: 50,
    speedLimitKmh: 50,
    lead: LeadVehicle(initialDistanceM: 35, speedKmh: 40),
    curvature: 0.004,
  );
  static const highway = DriveProfile(
    name: 'Highway',
    targetSpeedKmh: 120,
    speedLimitKmh: 120,
    lead: LeadVehicle(initialDistanceM: 90, speedKmh: 110),
  );
  static const laneDrift = DriveProfile(name: 'Lane drift', targetSpeedKmh: 100, speedLimitKmh: 100, laneDriftM: 1.1);
  static const leadBraking = DriveProfile(
    name: 'Lead car brakes',
    targetSpeedKmh: 90,
    speedLimitKmh: 100,
    lead: LeadVehicle(initialDistanceM: 45, speedKmh: 90, brakesAfter: Duration(seconds: 4)),
  );

  static const presets = [city, highway, laneDrift, leadBraking];
}

/// Simple longitudinal and lateral model at 30 Hz (the rate of a camera/radar ECU), feeding
/// the cluster's ADAS view: ego speed with adaptive cruise gap control, a lead vehicle, lane
/// geometry, forward-collision and lane-departure warnings, traction power, odometer and SoC.
///
/// It only moves the car while it is READY in DRIVE. State: the profile being played, or `null`.
@Riverpod(keepAlive: true)
class DrivingSimulator extends _$DrivingSimulator {
  static const tick = Duration(milliseconds: 33);
  static const _noObjectDistance = 250.0;
  static const _maxAccel = 2.5;
  static const _maxDecel = 6.0;

  /// Battery capacity: 100 kWh, so 1% = 3.6 MJ.
  static const _joulesPerPercent = 3.6e6;
  static const _kmPerPercent = 4.5;

  Timer? _timer;
  double _t = 0;
  double _egoMps = 0;
  double _leadMps = 0;
  double _leadDistanceM = _noObjectDistance;
  double _odometerM = 0;
  double _soc = 80;

  @override
  DriveProfile? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  TelemetrySimulator get _sim => ref.read(telemetrySimulatorProvider.notifier);

  void start(DriveProfile profile) {
    final values = ref.read(vssBrokerProvider);
    _t = 0;
    _egoMps = ((values[Vss.Vehicle.Speed.path] as double?) ?? 0) / 3.6;
    _leadMps = (profile.lead?.speedKmh ?? 0) / 3.6;
    _leadDistanceM = profile.lead?.initialDistanceM ?? _noObjectDistance;
    _odometerM = ((values[Vss.Vehicle.TraveledDistance.path] as int?) ?? 0).toDouble();
    _soc = (values[Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge.path] as double?) ?? 80;
    state = profile;
    _sim.report(Vss.Vehicle.ADAS.TrafficSignRecognition.SpeedLimit, profile.speedLimitKmh);
    _timer ??= Timer.periodic(tick, (_) => _step());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    state = null;
    _sim
      ..report(Vss.Vehicle.ADAS.ObstacleDetection.Front.Center.Distance, _noObjectDistance)
      ..report(Vss.Vehicle.ADAS.ObstacleDetection.Front.Center.IsWarning, false)
      ..report(Vss.Vehicle.ADAS.LaneDepartureDetection.IsWarning, false)
      ..report(Vss.Vehicle.Powertrain.TractionBattery.CurrentPower, 0.0);
  }

  void _step() {
    final profile = state;
    if (profile == null || !ref.mounted) return;
    final dt = tick.inMilliseconds / 1000;
    _t += dt;

    final values = SnapshotSignalReader(ref.read(vssBrokerProvider));
    final isDriving =
        ref.read(powerModeProvider) == PowerMode.ready &&
        values.read(Vss.Vehicle.Powertrain.Transmission.SelectedGear) == Gear.drive;
    final cruise = Vss.Vehicle.ADAS.CruiseControl;
    final isCruising = values.read(cruise.IsActive) ?? false;

    // Longitudinal: the "driver" or the cruise control picks a target, the lead car caps it.
    var targetMps = !isDriving
        ? 0.0
        : (isCruising ? values.read(cruise.SpeedSet) ?? profile.targetSpeedKmh : profile.targetSpeedKmh) / 3.6;
    final lead = profile.lead;
    if (lead != null) {
      if (lead.brakesAfter case final brakesAfter? when _t * 1000 > brakesAfter.inMilliseconds) {
        _leadMps = math.max(lead.brakedSpeedKmh / 3.6, _leadMps - 5 * dt);
      }
      _leadDistanceM = (_leadDistanceM + (_leadMps - _egoMps) * dt).clamp(4.0, _noObjectDistance);
      if (_leadDistanceM < 120) {
        final timeGap = isCruising ? values.read(cruise.AdaptiveIntervalSet) ?? 2.0 : 2.0;
        final desiredGap = timeGap * _egoMps + 6;
        targetMps = math.min(targetMps, _leadMps + 0.4 * (_leadDistanceM - desiredGap));
      }
    }
    final accel = ((math.max(0, targetMps) - _egoMps) / 1.0).clamp(-_maxDecel, _maxAccel);
    _egoMps = math.max(0, _egoMps + accel * dt);

    // Lateral: drift in the lane (lane keeping damps it) and a gently curving road.
    final isLaneKeeping = values.read(Vss.Vehicle.ADAS.LaneKeepingAssist.IsEnabled) ?? false;
    final moving = _egoMps > 1;
    final offset = moving ? profile.laneDriftM * (isLaneKeeping ? 0.25 : 1) * math.sin(0.6 * _t) : 0.0;
    final curvature = moving ? profile.curvature * math.sin(0.08 * _t) : 0.0;

    // Energy: inertia + rolling + aero. Negative = discharging, positive = regenerating.
    final powerW = -(1800 * accel * _egoMps + 150 * _egoMps + 0.45 * math.pow(_egoMps, 3));
    _soc = (_soc + powerW * dt / _joulesPerPercent).clamp(0, 100);
    _odometerM += _egoMps * dt;

    final closingMps = _egoMps - _leadMps;
    final timeToCollision = lead != null && closingMps > 0 ? _leadDistanceM / closingMps : double.infinity;

    final adas = Vss.Vehicle.ADAS;
    _sim
      ..report(Vss.Vehicle.Speed, _round(_egoMps * 3.6, 10))
      ..report(
        adas.ObstacleDetection.Front.Center.Distance,
        lead == null ? _noObjectDistance : _round(_leadDistanceM, 10),
      )
      ..report(adas.ObstacleDetection.Front.Center.IsWarning, timeToCollision < 2.5)
      ..report(adas.LaneKeepingAssist.LateralOffset, _round(offset, 100))
      ..report(adas.LaneKeepingAssist.Curvature, _round(curvature, 100000))
      ..report(adas.LaneDepartureDetection.IsWarning, !isLaneKeeping && offset.abs() > 0.75)
      ..report(Vss.Vehicle.Chassis.SteeringWheel.Angle, _round(math.atan(2.9 * curvature) * 15 * 180 / math.pi, 10))
      ..report(Vss.Vehicle.Powertrain.TractionBattery.CurrentPower, _round(powerW, 0.01))
      ..report(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge, _round(_soc, 100))
      ..report(Vss.Vehicle.Powertrain.Range, (_soc * _kmPerPercent * 1000).round())
      ..report(Vss.Vehicle.TraveledDistance, _odometerM.round());
  }

  /// Rounds to 1/[resolution] so the broker ignores sub-resolution noise.
  static double _round(double value, double resolution) => (value * resolution).round() / resolution;
}
