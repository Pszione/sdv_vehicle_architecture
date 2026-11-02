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

/// Switch for an actuator a person moves by hand (door handle, manual tailgate).
/// No command and no safety rule: the zone ECU reports the new state, logged as MANUAL.
class SimulatedManualSwitch extends ConsumerWidget {
  const SimulatedManualSwitch({super.key, required this.signal, required this.label});

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
        onChanged: (value) => ref.read(telemetrySimulatorProvider.notifier).operateManually(signal, value),
      ),
    );
  }
}

/// Switch that drives a seat `OccupancyStatus` sensor (OCCUPIED / EMPTY).
class SimulatedOccupancySwitch extends ConsumerWidget {
  const SimulatedOccupancySwitch({super.key, required this.signal, required this.label});

  final VssSignal<String> signal;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VehicleFeatureGuard(
      signal: signal,
      child: SwitchListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        value: ref.watchSignal(signal) == SeatOccupancy.occupied,
        onChanged: (occupied) => ref
            .read(telemetrySimulatorProvider.notifier)
            .report(signal, occupied ? SeatOccupancy.occupied : SeatOccupancy.empty),
      ),
    );
  }
}
