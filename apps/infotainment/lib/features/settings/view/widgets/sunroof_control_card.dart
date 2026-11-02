import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Sunroof (COVESA percent: 0 closed, 100 open, negative = tilted when the profile allows it).
/// The command is sent when the slider is released; after that, the slider follows the
/// real position reported by the actuator.
class SunroofControlCard extends ConsumerStatefulWidget {
  const SunroofControlCard({super.key});

  @override
  ConsumerState<SunroofControlCard> createState() => _SunroofControlCardState();
}

class _SunroofControlCardState extends ConsumerState<SunroofControlCard> {
  /// Value while the user drags; `null` shows the telemetry.
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final sunroof = Vss.Vehicle.Cabin.Sunroof;
    final position = ref.watchSignal(sunroof.Position) ?? 0;
    final meta = ref.watch(activeVehicleProfileProvider.select((p) => p.metaOf(sunroof.Position)));
    final min = (meta?.min ?? 0).toDouble();
    final max = (meta?.max ?? 100).toDouble();
    final isFaulted = ref.watchSignal(sunroof.IsFaulted) ?? false;

    return VehicleControlCard(
      icon: isFaulted ? Icons.warning_amber : Icons.wb_sunny_outlined,
      title: 'Sunroof',
      status: switch (position) {
        _ when isFaulted => 'ACTUATOR FAULT',
        < 0 => '${-position}% TILTED',
        0 => 'CLOSED',
        _ => '$position% OPEN',
      },
      statusColor: isFaulted ? Colors.redAccent : null,
      child: Column(
        children: [
          Slider(
            value: (_dragValue ?? position.toDouble()).clamp(min, max),
            min: min,
            max: max,
            divisions: ((max - min) / 5).round(),
            onChanged: (value) => setState(() => _dragValue = value),
            onChangeEnd: (value) {
              setState(() => _dragValue = null);
              ref.dispatchCommand(
                context,
                VehicleCommand(signal: sunroof.Position, value: value.round(), source: infotainmentCommandSource),
              );
            },
          ),
          SafetyPrecheckBanner(
            command: VehicleCommand(signal: sunroof.Position, value: 100, source: infotainmentCommandSource),
          ),
        ],
      ),
    );
  }
}
