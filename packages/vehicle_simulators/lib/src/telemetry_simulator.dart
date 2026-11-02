import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import 'e2e_transmitter.dart';
import 'simulation_scenario.dart';

part 'telemetry_simulator.g.dart';

/// Simulated world around the car, with four clearly separated paths:
///
/// - [report]: a **sensor** reading (speed, seat occupancy, SoC...) published to the [VssBroker],
///   as an ECU would. Actuators are refused. E2E-protected sensors (speed, brake pedal...) go
///   through an [E2eTransmitter] to the gateway's `E2eReceiver`, cyclically, and can be
///   corrupted with [injectE2eFault].
/// - [command]: an **actuator** request that goes through the `CommandDispatcher`, so every
///   safety rule applies (source `SIMULATOR`).
/// - [operateManually]: a person moving an actuator by hand (door handle, manual tailgate).
///   No command exists, so no rule applies; the zone ECU reports the latch. Logged as `MANUAL`.
/// - [forceActuatorState]: test-only override that writes an actuator state directly,
///   **bypassing every rule**, and logs it as `FORCED` in the audit log.
@Riverpod(keepAlive: true)
class TelemetrySimulator extends _$TelemetrySimulator {
  static const source = 'SIMULATOR';

  late E2eTransmitter _transmitter;
  var _isCyclicTransmissionRequested = false;

  @override
  void build() {
    final profile = ref.watch(activeVehicleProfileProvider);
    _transmitter = E2eTransmitter(
      deliver: (signal, frame) => ref.read(e2eReceiverProvider.notifier).receive(signal, frame),
    );
    // Sensor ECUs boot with their current reading, sent on the next cycle.
    final values = ref.read(vssBrokerProvider);
    for (final signal in E2eProtectedSignals.dataIds.keys) {
      if (values[signal.path] case final value? when profile.metaOf(signal) != null) _transmitter.seed(signal, value);
    }
    if (_isCyclicTransmissionRequested) _startCycleTimer();
  }

  /// Starts the cyclic transmission of the protected sensors, as real ECUs do (the app boot
  /// calls it). Without it, frames are only sent when a value is reported. Survives profile switches.
  void startCyclicTransmission() {
    if (_isCyclicTransmissionRequested) return;
    _isCyclicTransmissionRequested = true;
    _startCycleTimer();
    // First frames right away, so the gateway does not wait a full cycle after boot.
    if (!_isAsleep) _transmitter.sendCycle();
  }

  void _startCycleTimer() {
    final cycle = Timer.periodic(E2eProtectedSignals.cycleTime, (_) {
      if (!_isAsleep) _transmitter.sendCycle();
    });
    ref.onDispose(cycle.cancel);
  }

  /// Sleeping ECUs do not transmit.
  bool get _isAsleep => ref.read(powerModeProvider) == PowerMode.sleep;

  /// Publishes a sensor reading. Returns `notSupported` if the active profile lacks the sensor.
  SignalWriteResult report<T extends Object>(VssSignal<T> signal, T value) {
    final meta = ref.read(activeVehicleProfileProvider).metaOf(signal);
    if (meta == null) return SignalWriteResult.notSupported;
    if (meta.isActuator) {
      throw ArgumentError.value(signal, 'signal', 'is an actuator: use command() or forceActuatorState()');
    }
    if (E2eProtectedSignals.isProtected(signal)) return _transmitter.send(signal, value, isAsleep: _isAsleep);
    return ref.read(vssBrokerProvider.notifier).publish(signal, value);
  }

  /// Requests an actuator change through the dispatcher, like any other HMI.
  /// [from] overrides the source, e.g. to simulate the rear passenger climate panel.
  CommandResult command<T extends Object>(VssSignal<T> signal, T value, {String from = source}) =>
      ref.read(commandDispatcherProvider.notifier).dispatch(VehicleCommand(signal: signal, value: value, source: from));

  /// Injects [fault] on the link of an E2E-protected sensor (see [E2eFault]).
  void injectE2eFault(VssSignal<Object> signal, E2eFault fault) => _transmitter.injectFault(signal, fault);

  E2eFault e2eFaultOf(VssSignal<Object> signal) => _transmitter.faultOf(signal);

  /// An occupant or bystander moves an actuator by hand, e.g. opens a door with its handle.
  SignalWriteResult operateManually<T extends Object>(VssSignal<T> signal, T value) =>
      _writeActuator(signal, value, (logger) => logger.logManual(signal, value, source: source));

  /// Writes an actuator state directly, bypassing the dispatcher and its safety rules.
  /// Use it to reproduce states that rules would never allow (fault testing).
  ///
  /// The zonal ECU is not told, so its internal actuator state may differ until the next command.
  SignalWriteResult forceActuatorState<T extends Object>(VssSignal<T> signal, T value) =>
      _writeActuator(signal, value, (logger) => logger.logForced(signal, value, source: source));

  SignalWriteResult _writeActuator<T extends Object>(VssSignal<T> signal, T value, void Function(VehicleLogger) log) {
    final meta = ref.read(activeVehicleProfileProvider).metaOf(signal);
    if (meta == null) return SignalWriteResult.notSupported;
    if (!meta.isActuator) throw ArgumentError.value(signal, 'signal', 'is a sensor: use report()');
    if (!meta.accepts(value)) return SignalWriteResult.outOfRange;
    if (ref.read(vssBrokerProvider)[signal.path] == value) return SignalWriteResult.unchanged;

    log(ref.read(vehicleLoggerProvider.notifier));
    return ref.read(vssBrokerProvider.notifier).publish(signal, value);
  }

  /// Runs every step of the scenario in order. Steps before the first [SimulatedWait]
  /// run synchronously; the returned future completes after the last step.
  Future<void> apply(SimulationScenario scenario) async {
    for (final step in scenario.steps) {
      if (step is SimulatedWait) {
        await Future<void>.delayed(step.duration);
        if (!ref.mounted) return;
      } else {
        step.runOn(this);
      }
    }
  }
}
