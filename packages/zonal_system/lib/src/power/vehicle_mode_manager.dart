import 'dart:async';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../bus/zonal_command_bus.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_route.dart';

part 'vehicle_mode_manager.g.dart';

/// Vehicle mode manager (VMM), hosted by the central zone: owns the 12 V supply state
/// (`LowVoltageSystemState`), the high-voltage contactors (`IsPowerConnected`) and the
/// 12 V battery model.
///
/// It executes power requests that the dispatcher already approved
/// (`PowerModeRequestSafetyRule`), with realistic timing:
/// - READY: 12 V goes to START, the HV bus pre-charges for [prechargeTime], then the contactors close.
/// - OFF after driving: retained accessory power ([retainedAccessoryTime]) until a door opens.
/// - Key gone and car off: the car sleeps (12 V LOCK) after [sleepDelay].
///
/// Times are shortened so the simulation is watchable (real cars: minutes instead of seconds).
@Riverpod(keepAlive: true)
class VehicleModeManager extends _$VehicleModeManager {
  static const prechargeTime = Duration(milliseconds: 300);
  static const retainedAccessoryTime = Duration(seconds: 30);
  static const sleepDelay = Duration(seconds: 10);

  /// 12 V model: DC-DC converter output with HV connected, and resting voltage without it.
  static const dcDcVoltage = 14.1;
  static const restingVoltage = 12.6;
  static const _lowVoltageTick = Duration(seconds: 1);

  Timer? _precharge;
  Timer? _retainedAccessory;
  Timer? _sleep;

  @override
  void build() {
    final requests = ref
        .watch(zonalCommandBusProvider)
        .commandsFor(VehicleZone.central)
        .where((command) => command.deviceId == ZonalRoute.vehicleModeManager.deviceId)
        .listen((command) => _onRequest(command.command.value as String));
    ref.listen(vssValueProvider(Vss.Vehicle.Body.Keyless.KeyLocation), (_, key) => _onKeyMoved(key));
    for (final door in VehicleGroups.doors) {
      ref.listen(vssValueProvider(door.open), (_, isOpen) {
        if (isOpen == true) _onDoorOpened();
      });
    }
    // Read the keepAlive profile, not the autoDispose `isSignalSupportedProvider`: reading an
    // autoDispose provider during build schedules its disposal on the provider scheduler.
    final hasLowVoltageBattery =
        ref.read(activeVehicleProfileProvider).metaOf(Vss.Vehicle.LowVoltageBattery.CurrentVoltage) != null;
    final lowVoltageModel = hasLowVoltageBattery ? Timer.periodic(_lowVoltageTick, (_) => _stepLowVoltage()) : null;

    ref.onDispose(() {
      requests.cancel();
      lowVoltageModel?.cancel();
      _precharge?.cancel();
      _retainedAccessory?.cancel();
      _sleep?.cancel();
    });
  }

  VssBroker get _broker => ref.read(vssBrokerProvider.notifier);

  String? get _lowVoltageState => ref.read(vssBrokerProvider)[Vss.Vehicle.LowVoltageSystemState.path] as String?;

  void _onRequest(String request) {
    _broker.publish(Vss.Vehicle.PowerMode.Request, request);
    if (request == PowerModeRequest.off) return _powerOff();

    _retainedAccessory?.cancel();
    _sleep?.cancel();
    switch (request) {
      case PowerModeRequest.ready:
        _broker.publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.start);
        _precharge?.cancel();
        _precharge = Timer(prechargeTime, () {
          _precharge = null;
          _broker
            ..publish(Vss.Vehicle.Powertrain.TractionBattery.IsPowerConnected, true)
            ..publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.on);
        });
      case PowerModeRequest.on:
        _openContactors();
        _broker.publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.on);
      case PowerModeRequest.acc:
        _openContactors();
        _broker.publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.acc);
    }
  }

  void _openContactors() {
    _precharge?.cancel();
    _broker.publish(Vss.Vehicle.Powertrain.TractionBattery.IsPowerConnected, false);
  }

  /// After driving, accessories stay powered until a door opens (or a timeout).
  void _powerOff() {
    final wasOn = {LowVoltageSystemState.on, LowVoltageSystemState.start}.contains(_lowVoltageState);
    _openContactors();
    if (!wasOn) return _shutDown();

    _broker.publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.acc);
    _retainedAccessory?.cancel();
    _retainedAccessory = Timer(retainedAccessoryTime, _shutDown);
  }

  void _shutDown() {
    _retainedAccessory?.cancel();
    _retainedAccessory = null;
    _broker.publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.off);
    _scheduleSleep();
  }

  /// The car sleeps once it is off and the key has left.
  void _scheduleSleep() {
    _sleep?.cancel();
    final key = ref.read(vssBrokerProvider)[Vss.Vehicle.Body.Keyless.KeyLocation.path];
    if (key != KeyLocation.none) return;
    _sleep = Timer(sleepDelay, () {
      _sleep = null;
      if (_lowVoltageState == LowVoltageSystemState.off) {
        _broker.publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.lock);
      }
    });
  }

  void _onKeyMoved(Object? key) {
    if (key == KeyLocation.none) {
      if (_lowVoltageState == LowVoltageSystemState.off) _scheduleSleep();
      return;
    }
    // Key approaching: wake up (welcome lights, faster unlock).
    _sleep?.cancel();
    _wakeUp();
  }

  void _onDoorOpened() {
    if (_retainedAccessory != null) _shutDown();
    _wakeUp();
  }

  void _wakeUp() {
    if (_lowVoltageState == LowVoltageSystemState.lock) {
      _broker.publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.off);
    }
  }

  /// 12 V battery: the DC-DC converter charges it while HV is connected; otherwise the
  /// control units that are awake drain it (rates accelerated for the simulation).
  void _stepLowVoltage() {
    final signals = SnapshotSignalReader(ref.read(vssBrokerProvider));
    final voltage = signals.read(Vss.Vehicle.LowVoltageBattery.CurrentVoltage) ?? restingVoltage;
    final isHighVoltageConnected = signals.read(Vss.Vehicle.Powertrain.TractionBattery.IsPowerConnected) ?? false;

    final next = switch (voltage) {
      _ when isHighVoltageConnected => math.min(voltage + 0.1, dcDcVoltage),
      // Surface charge settles quickly once the DC-DC stops.
      > restingVoltage => math.max(voltage - 0.1, restingVoltage),
      _ => voltage - _drainPerSecond(signals),
    };
    // Rounded to 10 mV: the broker ignores repeated values, so a stable battery causes no rebuilds.
    _broker.publish(Vss.Vehicle.LowVoltageBattery.CurrentVoltage, (math.max(next, 9.0) * 100).round() / 100);
  }

  static double _drainPerSecond(SignalReader signals) {
    final base = switch (PowerMode.from(signals)) {
      PowerMode.sleep => 0.0002,
      PowerMode.off => 0.001,
      PowerMode.accessory => 0.004,
      _ => 0.006,
    };
    final isSentryArmed = signals.read(Vss.Vehicle.Cabin.Sentry.Mode) == SentryMode.armed;
    return base + (isSentryArmed ? 0.01 : 0);
  }
}
