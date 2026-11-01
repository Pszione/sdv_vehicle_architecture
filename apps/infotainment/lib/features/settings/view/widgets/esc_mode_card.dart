import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Electronic stability control. Turning it OFF is gated by speed, and it is
/// forced OFF while the rear differential is locked.
class EscModeCard extends ConsumerWidget {
  const EscModeCard({super.key});

  static const _labels = {
    EscMode.normal: 'Normal',
    EscMode.wet: 'Wet',
    EscMode.sportPlus: 'Sport+',
    EscMode.off: 'Off',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esc = Vss.Vehicle.ADAS.ESC.Mode;
    final modes = ref.watch(activeVehicleProfileProvider.select((p) => p.metaOf(esc)?.allowed))?.cast<String>() ?? [];
    final current = ref.watchSignal(esc);

    return VehicleControlCard(
      icon: Icons.track_changes,
      title: 'Stability control (ESC)',
      status: _labels[current] ?? current,
      statusColor: current == EscMode.off ? Colors.orangeAccent : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<String>(
            segments: [for (final mode in modes) ButtonSegment(value: mode, label: Text(_labels[mode] ?? mode))],
            selected: {?current},
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            onSelectionChanged: (selection) => ref.dispatchCommand(
              context,
              VehicleCommand(signal: esc, value: selection.first, source: infotainmentCommandSource),
            ),
          ),
          if (current != EscMode.off)
            SafetyPrecheckBanner(
              command: VehicleCommand(signal: esc, value: EscMode.off, source: infotainmentCommandSource),
            ),
        ],
      ),
    );
  }
}
