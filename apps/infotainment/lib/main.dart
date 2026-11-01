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
      commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
    ],
  );

  // Boot: zonal ECUs and the audit log must be alive before the first command.
  container
    ..read(zonalSystemProvider)
    ..read(vehicleLoggerProvider);

  runApp(UncontrolledProviderScope(container: container, child: const EvSuvApp()));
}
