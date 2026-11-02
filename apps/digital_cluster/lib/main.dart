import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:zonal_system/zonal_system.dart';

import 'app/cluster_app.dart';

/// Composition root of the cluster in **standalone mode**: it runs its own vehicle core
/// (broker, dispatcher, zonal ECUs, simulators), so it can be developed without the
/// infotainment. With an IPC bridge (see docs/ipc-bridge.md) it would subscribe to the
/// infotainment's broker instead and keep only the read-only HMI.
void main() {
  final container = ProviderContainer(
    overrides: [
      initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
      commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
    ],
  );

  // Listen, not read: Riverpod 3 does not re-evaluate providers nobody listens to.
  container
    ..listen(zonalSystemProvider, (_, _) {})
    ..listen(vehicleLoggerProvider, (_, _) {})
    ..listen(vehicleBehaviorEngineProvider, (_, _) {})
    ..listen(e2eReceiverProvider, (_, _) {})
    ..listen(telemetrySimulatorProvider, (_, _) {})
    ..listen(driverMessageCenterProvider, (_, _) {});
  container.read(e2eReceiverProvider.notifier).startDeadlineMonitoring();
  container.read(telemetrySimulatorProvider.notifier).startCyclicTransmission();

  runApp(UncontrolledProviderScope(container: container, child: const ClusterApp()));
}
