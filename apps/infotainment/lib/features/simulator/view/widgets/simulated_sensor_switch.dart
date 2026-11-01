import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// Switch that drives a simulated boolean sensor. Hidden when the active profile lacks it.
class SimulatedSensorSwitch extends ConsumerWidget {
  const SimulatedSensorSwitch({super.key, required this.signal, required this.label});

  final VssSignal<bool> signal;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VehicleFeatureGuard(
      signal: signal,
      child: SwitchListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        value: ref.watchSignal(signal) ?? false,
        onChanged: (value) => ref.read(telemetrySimulatorProvider.notifier).report(signal, value),
      ),
    );
  }
}
