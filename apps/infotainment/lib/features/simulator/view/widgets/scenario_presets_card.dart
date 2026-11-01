import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// One-tap scenarios that put the car in a known situation.
class ScenarioPresetsCard extends ConsumerWidget {
  const ScenarioPresetsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VehicleControlCard(
      icon: Icons.play_circle_outline,
      title: 'Test scenarios',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final scenario in SimulationScenario.presets)
            Tooltip(
              message: scenario.description,
              child: ActionChip(
                label: Text(scenario.name),
                onPressed: () => ref.read(telemetrySimulatorProvider.notifier).apply(scenario),
              ),
            ),
        ],
      ),
    );
  }
}
