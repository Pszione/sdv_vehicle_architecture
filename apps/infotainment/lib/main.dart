import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';
import 'package:zonal_system/zonal_system.dart';

import 'app/ev_suv_app.dart';

/// Composition root: define o modelo do carro e liga o domínio ao barramento zonal.
void main() {
  final container = ProviderContainer(
    overrides: [
      initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
      commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
    ],
  );

  // Boot: ECUs zonais e audit log precisam estar vivos antes do primeiro comando.
  container
    ..read(zonalSystemProvider)
    ..read(vehicleLoggerProvider);

  runApp(UncontrolledProviderScope(container: container, child: const EvSuvApp()));
}
