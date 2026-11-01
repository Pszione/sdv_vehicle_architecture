import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Valet Mode: locks the glovebox and frunk, freezes driving settings and caps speed.
class ValetModeCard extends ConsumerWidget {
  const ValetModeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValet = ref.watchSignal(Vss.Vehicle.Cabin.ValetMode.IsEnabled) ?? false;

    return VehicleControlCard(
      icon: Icons.room_service_outlined,
      title: 'Valet Mode',
      status: isValet ? 'ACTIVE' : null,
      statusColor: Colors.amber,
      child: Column(
        children: [
          VehicleCommandSwitch(
            signal: Vss.Vehicle.Cabin.ValetMode.IsEnabled,
            title: 'Valet Mode',
            subtitle: 'Caps speed at ${ValetModeSafetyRule.maxSpeedKmh.toInt()} km/h and locks storage',
            source: infotainmentCommandSource,
          ),
          VehicleCommandSwitch(
            signal: Vss.Vehicle.Cabin.Glovebox.IsLocked,
            title: 'Glovebox locked',
            source: infotainmentCommandSource,
            precheckValue: false,
          ),
        ],
      ),
    );
  }
}
