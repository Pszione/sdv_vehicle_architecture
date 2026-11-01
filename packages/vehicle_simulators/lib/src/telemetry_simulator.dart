import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import 'simulation_scenario.dart';

part 'telemetry_simulator.g.dart';

/// Fake sensors: publishes readings to the [VssBroker] as if they came from ECUs.
///
/// This is the only place outside the zonal ECUs allowed to publish telemetry.
/// The broker still validates every value against the spec and the active
/// profile, so a reading the car does not have is ignored ([SignalWriteResult.notSupported]).
@Riverpod(keepAlive: true)
class TelemetrySimulator extends _$TelemetrySimulator {
  @override
  void build() {}

  SignalWriteResult report<T extends Object>(VssSignal<T> signal, T value) =>
      ref.read(vssBrokerProvider.notifier).publish(signal, value);

  /// Publishes every reading of the scenario that exists in the active profile.
  void apply(SimulationScenario scenario) {
    final broker = ref.read(vssBrokerProvider.notifier);
    for (final reading in scenario.readings) {
      reading.publishTo(broker);
    }
  }
}
