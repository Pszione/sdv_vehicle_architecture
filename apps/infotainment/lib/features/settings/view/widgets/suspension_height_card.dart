import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Air suspension ride height. OFFROAD_MAX is gated by speed.
class SuspensionHeightCard extends ConsumerWidget {
  const SuspensionHeightCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = Vss.Vehicle.Chassis.Suspension.Height;
    final levels =
        ref.watch(activeVehicleProfileProvider.select((p) => p.metaOf(height)?.allowed))?.cast<String>() ?? [];
    final current = ref.watchSignal(height);

    return VehicleControlCard(
      icon: Icons.height,
      title: 'Air suspension height',
      status: current,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<String>(
              segments: [for (final level in levels) ButtonSegment(value: level, label: Text(level))],
              selected: {?current},
              emptySelectionAllowed: true,
              onSelectionChanged: (selection) => ref.dispatchCommand(
                context,
                VehicleCommand(signal: height, value: selection.first, source: infotainmentCommandSource),
              ),
            ),
          ),
          if (current != SuvAirSuspensionSafetyRule.offroadMax)
            SafetyPrecheckBanner(
              command: VehicleCommand(
                signal: height,
                value: SuvAirSuspensionSafetyRule.offroadMax,
                source: infotainmentCommandSource,
              ),
            ),
        ],
      ),
    );
  }
}
