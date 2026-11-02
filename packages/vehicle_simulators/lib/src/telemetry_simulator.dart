import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import 'simulation_scenario.dart';

part 'telemetry_simulator.g.dart';

/// Simulated world around the car, with three clearly separated paths:
///
/// - [report]: a **sensor** reading (speed, door open, SoC...) published to the [VssBroker],
///   as an ECU would. Actuators are refused.
/// - [command]: an **actuator** request that goes through the `CommandDispatcher`, so every
///   safety rule applies (source `SIMULATOR`).
/// - [forceActuatorState]: test-only override that writes an actuator state directly,
///   **bypassing every rule**, and logs it as `FORCED` in the audit log.
@Riverpod(keepAlive: true)
class TelemetrySimulator extends _$TelemetrySimulator {
  static const source = 'SIMULATOR';

  @override
  void build() {}

  /// Publishes a sensor reading. Returns `notSupported` if the active profile lacks the sensor.
  SignalWriteResult report<T extends Object>(VssSignal<T> signal, T value) {
    final meta = ref.read(activeVehicleProfileProvider).metaOf(signal);
    if (meta == null) return SignalWriteResult.notSupported;
    if (meta.isActuator) {
      throw ArgumentError.value(signal, 'signal', 'is an actuator: use command() or forceActuatorState()');
    }
    return ref.read(vssBrokerProvider.notifier).publish(signal, value);
  }

  /// Requests an actuator change through the dispatcher, like any other HMI.
  /// [from] overrides the source, e.g. to simulate the rear passenger climate panel.
  CommandResult command<T extends Object>(VssSignal<T> signal, T value, {String from = source}) =>
      ref.read(commandDispatcherProvider.notifier).dispatch(VehicleCommand(signal: signal, value: value, source: from));

  /// Writes an actuator state directly, bypassing the dispatcher and its safety rules.
  /// Use it to reproduce states that rules would never allow (fault testing).
  ///
  /// The zonal ECU is not told, so its internal actuator state may differ until the next command.
  SignalWriteResult forceActuatorState<T extends Object>(VssSignal<T> signal, T value) {
    final meta = ref.read(activeVehicleProfileProvider).metaOf(signal);
    if (meta == null) return SignalWriteResult.notSupported;
    if (!meta.isActuator) throw ArgumentError.value(signal, 'signal', 'is a sensor: use report()');
    if (!meta.accepts(value)) return SignalWriteResult.outOfRange;
    if (ref.read(vssBrokerProvider)[signal.path] == value) return SignalWriteResult.unchanged;

    ref.read(vehicleLoggerProvider.notifier).logForced(signal, value, source: source);
    return ref.read(vssBrokerProvider.notifier).publish(signal, value);
  }

  /// Runs every step of the scenario in order.
  void apply(SimulationScenario scenario) {
    for (final step in scenario.steps) {
      step.runOn(this);
    }
  }
}
