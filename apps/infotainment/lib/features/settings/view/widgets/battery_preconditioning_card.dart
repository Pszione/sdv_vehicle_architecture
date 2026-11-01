import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Battery preconditioning (for DC fast charging). Gated by SoC.
class BatteryPreconditioningCard extends ConsumerWidget {
  const BatteryPreconditioningCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = Vss.Vehicle.Powertrain.TractionBattery;
    final isEnabled = ref.watchSignal(battery.Preconditioning.IsEnabled) ?? false;
    final soc = ref.watchSignal(battery.StateOfCharge);

    return VehicleControlCard(
      icon: Icons.battery_charging_full,
      title: 'Battery preconditioning',
      status: soc == null ? null : 'SoC ${soc.round()}%',
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Precondition for fast charging'),
            value: isEnabled,
            onChanged: (value) => ref.dispatchCommand(
              context,
              VehicleCommand(
                signal: battery.Preconditioning.IsEnabled,
                value: value,
                source: infotainmentCommandSource,
              ),
            ),
          ),
          if (!isEnabled)
            SafetyPrecheckBanner(
              command: VehicleCommand(
                signal: battery.Preconditioning.IsEnabled,
                value: true,
                source: infotainmentCommandSource,
              ),
            ),
        ],
      ),
    );
  }
}
