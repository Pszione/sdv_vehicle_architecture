import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infotainment/features/climate/view/climate_screen.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';
import 'package:zonal_system/zonal_system.dart';

void main() {
  testWidgets('should warm the passenger and rear zones with the driver when SYNC is on', (tester) async {
    tester.view
      ..physicalSize = const Size(1180, 820)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container =
        ProviderContainer(
            overrides: [
              initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
              commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
            ],
          )
          ..read(zonalSystemProvider)
          ..read(vehicleBehaviorEngineProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: ClimateScreen())),
      ),
    );

    await tester.tap(find.text('Sync'));
    await tester.pump();
    await tester.tap(find.byTooltip('Driver warmer'));
    await tester.pump(); // driver confirmed, SYNC behavior scheduled
    await tester.pump(); // passenger and rear confirmed

    expect(find.text('21.5°'), findsNWidgets(3));

    // Stop the cabin thermal model timer before the test ends.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });
}
