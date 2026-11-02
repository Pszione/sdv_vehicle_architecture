import 'package:digital_cluster/features/cluster/view/cluster_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';

void main() {
  testWidgets('should show -- instead of a frozen speed when the speed sender freezes', (tester) async {
    tester.view
      ..physicalSize = const Size(1180, 820)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile)],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ClusterScreen()),
      ),
    );
    final simulator = container.read(telemetrySimulatorProvider.notifier)..report(Vss.Vehicle.Speed, 80.0);
    await tester.pump();
    expect(find.text('80'), findsOneWidget);

    simulator.injectE2eFault(Vss.Vehicle.Speed, E2eFault.frozenSender);
    for (var frame = 0; frame < 3; frame++) {
      simulator.report(Vss.Vehicle.Speed, 120.0);
    }
    await tester.pump();

    expect(find.text('--'), findsOneWidget);
    expect(find.text('80'), findsNothing);

    // Stop the ADAS view ticker before the test ends.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });
}
