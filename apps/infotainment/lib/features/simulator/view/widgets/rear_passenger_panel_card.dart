import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// Simulates the rear passengers' climate panel (source `REAR_PANEL`), so the
/// rear climate lock can be tried.
class RearPassengerPanelCard extends ConsumerWidget {
  const RearPassengerPanelCard({super.key});

  static const _step = 0.5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rear = VehicleGroups.rearHvacStations;
    final temperature = ref.watchSignal(rear.first.temperature) ?? 21.0;
    final isLocked = ref.watchSignal(Vss.Vehicle.Cabin.HVAC.IsRearControlLocked) ?? false;

    void change(double delta) {
      final simulator = ref.read(telemetrySimulatorProvider.notifier);
      for (final station in rear) {
        final result = simulator.command(
          station.temperature,
          (temperature + delta).clamp(16.0, 30.0),
          from: RearClimateLockSafetyRule.rearPanelSource,
        );
        if (!result.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(backgroundColor: Colors.red.shade900, content: Text(result.message ?? 'Rejected.')),
            );
          return;
        }
      }
    }

    return VehicleFeatureGuard(
      signal: rear.first.temperature,
      child: VehicleControlCard(
        icon: Icons.airline_seat_recline_normal,
        title: 'Rear passenger climate panel',
        status: isLocked ? 'LOCKED' : null,
        statusColor: Colors.orangeAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(icon: const Icon(Icons.remove), onPressed: () => change(-_step)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('${temperature.toStringAsFixed(1)}°', style: Theme.of(context).textTheme.headlineMedium),
            ),
            IconButton.filledTonal(icon: const Icon(Icons.add), onPressed: () => change(_step)),
          ],
        ),
      ),
    );
  }
}
