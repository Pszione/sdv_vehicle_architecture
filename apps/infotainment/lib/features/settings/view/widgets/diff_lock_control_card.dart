import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Rear differential lock (4x4). Locking is gated by speed and steering angle.
class DiffLockControlCard extends ConsumerWidget {
  const DiffLockControlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffLock = Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked;
    final isLocked = ref.watchSignal(diffLock) ?? false;

    return VehicleControlCard(
      icon: Icons.all_inclusive,
      title: 'Rear differential lock',
      status: isLocked ? 'LOCKED' : 'UNLOCKED',
      statusColor: isLocked ? Colors.amber : Colors.white54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => ref.dispatchCommand(
              context,
              VehicleCommand(signal: diffLock, value: !isLocked, source: infotainmentCommandSource),
            ),
            child: Text(isLocked ? 'RELEASE' : 'ENGAGE LOCK'),
          ),
          if (!isLocked)
            SafetyPrecheckBanner(
              command: VehicleCommand(signal: diffLock, value: true, source: infotainmentCommandSource),
            ),
        ],
      ),
    );
  }
}
