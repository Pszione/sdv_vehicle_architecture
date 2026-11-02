import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Door locks. Each row only appears if the profile has that door, and its
/// state comes from the telemetry confirmed by the zonal ECU, not from the command sent.
class DoorLockControlCard extends StatelessWidget {
  const DoorLockControlCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VehicleControlCard(
      icon: Icons.lock_outline,
      title: 'Door locks',
      child: Column(
        children: [
          for (final door in VehicleGroups.doors) _DoorLockRow(label: door.label, lock: door.lock, open: door.open),
        ],
      ),
    );
  }
}

class _DoorLockRow extends ConsumerWidget {
  const _DoorLockRow({required this.label, required this.lock, required this.open});

  final String label;
  final VssSignal<bool> lock;
  final VssSignal<bool> open;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = ref.watchSignal(lock) ?? false;
    final isOpen = ref.watchSignal(open) ?? false;

    return VehicleFeatureGuard(
      signal: lock,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(isLocked ? Icons.lock : Icons.lock_open),
            title: Text(label),
            subtitle: Text(isOpen ? 'Open' : 'Closed'),
            value: isLocked,
            onChanged: (value) => ref.dispatchCommand(
              context,
              VehicleCommand(signal: lock, value: value, source: infotainmentCommandSource),
            ),
          ),
          if (!isLocked)
            SafetyPrecheckBanner(
              command: VehicleCommand(signal: lock, value: true, source: infotainmentCommandSource),
            ),
        ],
      ),
    );
  }
}
