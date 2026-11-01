import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Trava da porta dianteira esquerda. O estado vem da telemetria confirmada
/// pela ECU zonal, não do comando enviado.
class DoorLockControlCard extends ConsumerWidget {
  const DoorLockControlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final door = Vss.Vehicle.Cabin.Door.Row1.Left;
    final isLocked = ref.watchSignal(door.IsLocked) ?? false;
    final isAjar = ref.watchSignal(door.IsAjar) ?? false;

    return Card(
      child: SwitchListTile(
        secondary: Icon(isLocked ? Icons.lock : Icons.lock_open),
        title: const Text('Trava da porta dianteira esquerda'),
        subtitle: isAjar ? const Text('Porta aberta') : null,
        value: isLocked,
        onChanged: (lock) => ref.dispatchCommand(
          context,
          VehicleCommand(signal: door.IsLocked, value: lock, source: infotainmentCommandSource),
        ),
      ),
    );
  }
}
