import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Gear selector (P/R/N/D). Exercises the transmission and EV charging rules.
class GearSelectorCard extends ConsumerWidget {
  const GearSelectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gear = Vss.Vehicle.Powertrain.Transmission.SelectedGear;
    final gears = ref.watch(activeVehicleProfileProvider.select((p) => p.metaOf(gear)?.allowed))?.cast<String>() ?? [];
    final current = ref.watchSignal(gear);

    return VehicleControlCard(
      icon: Icons.settings_input_component,
      title: 'Gear selector',
      status: current,
      child: SegmentedButton<String>(
        segments: [for (final g in gears) ButtonSegment(value: g, label: Text(g[0]), tooltip: g)],
        selected: {?current},
        emptySelectionAllowed: true,
        showSelectedIcon: false,
        onSelectionChanged: (selection) => ref.dispatchCommand(
          context,
          VehicleCommand(signal: gear, value: selection.first, source: infotainmentCommandSource),
        ),
      ),
    );
  }
}
