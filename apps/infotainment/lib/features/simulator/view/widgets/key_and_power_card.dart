import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';
import 'package:zonal_system/zonal_system.dart';

/// Key position, start button and power requests, plus what the vehicle mode manager
/// does with them: power mode, 12 V battery and each zone's bus (awake/asleep).
class KeyAndPowerCard extends ConsumerWidget {
  const KeyAndPowerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = Vss.Vehicle.Body.Keyless.KeyLocation;
    final location = ref.watchSignal(key);
    final voltage = ref.watchSignal(Vss.Vehicle.LowVoltageBattery.CurrentVoltage);
    final simulator = ref.read(telemetrySimulatorProvider.notifier);

    void request(String mode) => ref.dispatchCommand(
      context,
      VehicleCommand(signal: Vss.Vehicle.PowerMode.Request, value: mode, source: TelemetrySimulator.source),
    );

    return VehicleFeatureGuard(
      signal: Vss.Vehicle.PowerMode.Request,
      child: VehicleControlCard(
        icon: Icons.key,
        title: 'Key & power',
        status: voltage == null ? null : '12 V: ${voltage.toStringAsFixed(2)} V',
        statusColor: (voltage ?? 12.6) < ParkedModeSafetyRule.minLowVoltage ? Colors.redAccent : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('Key'),
                const SizedBox(width: 12),
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: KeyLocation.none, label: Text('Away')),
                      ButtonSegment(value: KeyLocation.near, label: Text('Near')),
                      ButtonSegment(value: KeyLocation.inside, label: Text('Inside')),
                    ],
                    selected: {?location},
                    onSelectionChanged: (selection) => simulator.report(key, selection.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('Brake + START'),
                  onPressed: () {
                    simulator.report(Vss.Vehicle.Chassis.Brake.PedalPosition, 100);
                    request(PowerModeRequest.ready);
                  },
                ),
                OutlinedButton(onPressed: () => request(PowerModeRequest.on), child: const Text('ON')),
                OutlinedButton(onPressed: () => request(PowerModeRequest.acc), child: const Text('ACC')),
                OutlinedButton(onPressed: () => request(PowerModeRequest.off), child: const Text('OFF')),
              ],
            ),
            const SizedBox(height: 12),
            const _ZoneBusStates(),
          ],
        ),
      ),
    );
  }
}

class _ZoneBusStates extends ConsumerWidget {
  const _ZoneBusStates();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final states = ref.watch(zoneNetworkManagementProvider);

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        for (final MapEntry(key: zone, value: state) in states.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: switch (state) {
                  NmState.networkMode => Colors.greenAccent,
                  NmState.prepareBusSleep => Colors.amberAccent,
                  NmState.busSleep => Colors.white24,
                },
              ),
              const SizedBox(width: 4),
              Text(
                '${zone.name.toUpperCase()} ${state == NmState.busSleep ? 'asleep' : 'awake'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
      ],
    );
  }
}
