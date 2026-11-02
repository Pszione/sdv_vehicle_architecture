import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';
import 'package:zonal_system/zonal_system.dart';

import 'app/ev_suv_app.dart';

/// Composition root: picks the car model and wires the domain to the zonal bus.
void main() {
  final container = ProviderContainer(
    overrides: [
      initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
      commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
    ],
  );

  // Boot: zonal ECUs, the audit log and the vehicle behaviors must be alive before the first command.
  container
    ..read(zonalSystemProvider)
    ..read(vehicleLoggerProvider)
    ..read(vehicleBehaviorEngineProvider);

  runApp(UncontrolledProviderScope(container: container, child: const EvSuvApp()));
}
