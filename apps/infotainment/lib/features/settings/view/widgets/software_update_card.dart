import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Over-the-air software update.
class SoftwareUpdateCard extends ConsumerWidget {
  const SoftwareUpdateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ota = Vss.Vehicle.Software.OTA;
    final isInstalling = ref.watchSignal(ota.IsInstalling) ?? false;
    final install = VehicleCommand(signal: ota.IsInstalling, value: true, source: infotainmentCommandSource);

    return VehicleControlCard(
      icon: Icons.system_update,
      title: 'Software update',
      status: isInstalling ? 'INSTALLING' : ref.watchSignal(ota.Status)?.replaceAll('_', ' '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Requires PARK, more than 30% battery, every door locked and nobody inside.'),
          const SizedBox(height: 8),
          FilledButton.icon(
            icon: const Icon(Icons.download),
            label: Text(isInstalling ? 'INSTALLING…' : 'INSTALL UPDATE'),
            onPressed: isInstalling ? null : () => ref.dispatchCommand(context, install),
          ),
          if (!isInstalling) SafetyPrecheckBanner(command: install),
        ],
      ),
    );
  }
}
