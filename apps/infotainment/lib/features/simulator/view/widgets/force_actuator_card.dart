import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// Forces actuator states that the safety rules would never allow, for fault testing.
/// Every action bypasses the dispatcher and is logged as FORCED.
class ForceActuatorCard extends ConsumerWidget {
  const ForceActuatorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulator = ref.read(telemetrySimulatorProvider.notifier);
    final actions = <(String, IconData, VoidCallback)>[
      (
        'Diff locked',
        Icons.all_inclusive,
        () => simulator.forceActuatorState(Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked, true),
      ),
      (
        'Gear DRIVE',
        Icons.settings_input_component,
        () => simulator.forceActuatorState(Vss.Vehicle.Powertrain.Transmission.SelectedGear, Gear.drive),
      ),
      ('ESC off', Icons.track_changes, () => simulator.forceActuatorState(Vss.Vehicle.ADAS.ESC.Mode, EscMode.off)),
      (
        'All doors unlocked',
        Icons.lock_open,
        () {
          for (final door in VehicleGroups.doors) {
            simulator.forceActuatorState(door.lock, false);
          }
        },
      ),
      (
        'OTA installing',
        Icons.system_update,
        () => simulator.forceActuatorState(Vss.Vehicle.Software.OTA.IsInstalling, true),
      ),
    ];

    return VehicleControlCard(
      icon: Icons.warning_amber_rounded,
      title: 'Force actuator state',
      status: 'BYPASSES RULES',
      statusColor: Colors.redAccent,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (label, icon, onPressed) in actions)
            ActionChip(
              avatar: Icon(icon, size: 16, color: Colors.redAccent),
              label: Text(label),
              side: const BorderSide(color: Colors.redAccent),
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}
