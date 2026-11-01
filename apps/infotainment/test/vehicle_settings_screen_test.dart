import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infotainment/features/settings/view/vehicle_settings_screen.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';

void main() {
  testWidgets('should show the sunroof card only when the active profile has a sunroof', (tester) async {
    final container = ProviderContainer.test(
      overrides: [initialVehicleProfileProvider.overrideWithValue(entryProfile)],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: VehicleSettingsScreen())),
      ),
    );

    expect(find.text('Sunroof'), findsNothing);

    container.read(activeVehicleProfileProvider.notifier).setProfile(premiumProfile);
    await tester.pump();

    expect(find.text('Sunroof'), findsOneWidget);
  });
}
