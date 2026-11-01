import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Sunroof: the command is sent when the slider is released. After that, the
/// slider follows the real position reported by the actuator.
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
    final position = ref.watchSignal(sunroof.Position) ?? 0.0;
    final isFaulted = ref.watchSignal(sunroof.IsFaulted) ?? false;

    return VehicleControlCard(
      icon: isFaulted ? Icons.warning_amber : Icons.wb_sunny_outlined,
      title: 'Sunroof',
      status: isFaulted ? 'ACTUATOR FAULT' : '${(position * 100).round()}% OPEN',
      statusColor: isFaulted ? Colors.redAccent : null,
      child: Column(
        children: [
          Slider(
            value: _dragValue ?? position,
            onChanged: (value) => setState(() => _dragValue = value),
            onChangeEnd: (value) {
              setState(() => _dragValue = null);
              ref.dispatchCommand(
                context,
                VehicleCommand(signal: sunroof.Position, value: value, source: infotainmentCommandSource),
              );
            },
          ),
          SafetyPrecheckBanner(
            command: VehicleCommand(signal: sunroof.Position, value: 1.0, source: infotainmentCommandSource),
          ),
        ],
      ),
    );
  }
}
