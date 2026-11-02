import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../domain/vehicle_zone.dart';

part 'zone_network_management.g.dart';

/// Network management state of a zone's bus, after AUTOSAR CanNm.
enum NmState {
  /// Bus asleep: the zone only reacts to wake-up sources.
  busSleep,

  /// Bus awake: frames flow, commands are executed.
  networkMode,

  /// No one needs the zone any more: short grace time before the bus sleeps.
  prepareBusSleep,
}

/// Keeps each zone awake while someone needs it, and lets it sleep otherwise.
///
/// Every zone is awake unless the car is in [PowerMode.sleep]. While asleep, a zone stays
/// awake for its "keep-awake" users (Sentry cameras, charging, OTA, Camp/Dog Mode), and a
/// command to a sleeping zone wakes it ([requestWake]): the frame waits for [wakeUpLatency].
@Riverpod(keepAlive: true)
class ZoneNetworkManagement extends _$ZoneNetworkManagement {
  static const wakeUpLatency = Duration(milliseconds: 150);
  static const prepareBusSleepTime = Duration(milliseconds: 500);

  /// How long a zone woken by a command stays awake before sleeping again.
  static const commandWakeHold = Duration(seconds: 5);

  final _sleepTimers = <VehicleZone, Timer>{};
  final _commandHolds = <VehicleZone, Timer>{};

  static final _keepAwakeSignals = <VssSignal<Object>>{
    Vss.Vehicle.Cabin.Sentry.Mode,
    Vss.Vehicle.Cabin.HVAC.CampMode.IsEnabled,
    Vss.Vehicle.Cabin.HVAC.DogMode.IsEnabled,
  };

  @override
  Map<VehicleZone, NmState> build() {
    ref.listen(powerModeProvider, (_, _) => _reevaluate());
    for (final signal in _keepAwakeSignals) {
      ref.listen(vssValueProvider(signal), (_, _) => _reevaluate());
    }
    ref.onDispose(() {
      for (final timer in [..._sleepTimers.values, ..._commandHolds.values]) {
        timer.cancel();
      }
    });
    final awake = _zonesThatMustBeAwake();
    return {for (final zone in VehicleZone.values) zone: awake.contains(zone) ? NmState.networkMode : NmState.busSleep};
  }

  /// Wakes [zone] for a command. Returns how long the frame must wait before the zone can process it.
  Duration requestWake(VehicleZone zone) {
    if (ref.read(powerModeProvider) != PowerMode.sleep) return Duration.zero;

    final wasAsleep = state[zone] == NmState.busSleep;
    _commandHolds[zone]?.cancel();
    _commandHolds[zone] = Timer(commandWakeHold, () {
      _commandHolds.remove(zone);
      if (ref.mounted) _reevaluate();
    });
    _reevaluate();
    return wasAsleep ? wakeUpLatency : Duration.zero;
  }

  void _reevaluate() {
    final awake = _zonesThatMustBeAwake();
    final next = {...state};
    for (final zone in VehicleZone.values) {
      if (awake.contains(zone)) {
        _sleepTimers.remove(zone)?.cancel();
        next[zone] = NmState.networkMode;
      } else if (state[zone] == NmState.networkMode) {
        next[zone] = NmState.prepareBusSleep;
        _sleepTimers[zone] = Timer(prepareBusSleepTime, () {
          _sleepTimers.remove(zone);
          if (ref.mounted) state = {...state, zone: NmState.busSleep};
        });
      }
    }
    state = next;
  }

  Set<VehicleZone> _zonesThatMustBeAwake() {
    if (ref.read(powerModeProvider) != PowerMode.sleep) return VehicleZone.values.toSet();

    final signals = SnapshotSignalReader(ref.read(vssBrokerProvider));
    final isSentryArmed = signals.read(Vss.Vehicle.Cabin.Sentry.Mode) == SentryMode.armed;
    final isClimateHolding =
        (signals.read(Vss.Vehicle.Cabin.HVAC.CampMode.IsEnabled) ?? false) ||
        (signals.read(Vss.Vehicle.Cabin.HVAC.DogMode.IsEnabled) ?? false);
    return {
      // Sentry cameras sit in the body zones; the central zone records and keeps the gateway up.
      if (isSentryArmed) ...VehicleZone.values,
      if (isClimateHolding) VehicleZone.central,
      ..._commandHolds.keys,
    };
  }
}
