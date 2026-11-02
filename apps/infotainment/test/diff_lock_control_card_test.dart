import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infotainment/features/settings/view/widgets/diff_lock_control_card.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:zonal_system/zonal_system.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test(
      overrides: [
        initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
        commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
      ],
    )..read(zonalSystemProvider);
  });

  Future<void> pumpCard(WidgetTester tester) => tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: Scaffold(body: DiffLockControlCard())),
    ),
  );

  testWidgets('should show the rule message and keep the differential unlocked when engaging at 45 km/h', (
    tester,
  ) async {
    await pumpCard(tester);
    container.read(telemetrySimulatorProvider.notifier).report(Vss.Vehicle.Speed, 45.0);
    await tester.pump();

    await tester.tap(find.text('ENGAGE LOCK'));
    await tester.pump();

    expect(find.text('UNLOCKED'), findsOneWidget);
    // Pre-check banner + rejection SnackBar.
    expect(find.textContaining('below 30 km/h'), findsNWidgets(2));
  });

  testWidgets('should lock the differential when the car is parked and aligned', (tester) async {
    await pumpCard(tester);
    container.read(telemetrySimulatorProvider.notifier).apply(SimulationScenario.presets.first);
    await tester.pump();

    await tester.tap(find.text('ENGAGE LOCK'));
    await tester.pump();

    expect(find.text('LOCKED'), findsOneWidget);
  });
}
