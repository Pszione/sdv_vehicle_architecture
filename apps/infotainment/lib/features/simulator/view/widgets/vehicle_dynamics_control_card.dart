import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'simulated_sensor_slider.dart';

/// Simulated vehicle dynamics: speed and steering angle, plus quick shortcuts.
class VehicleDynamicsControlCard extends ConsumerWidget {
  const VehicleDynamicsControlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulator = ref.read(telemetrySimulatorProvider.notifier);
    final speed = Vss.Vehicle.Speed;
    final steering = Vss.Vehicle.Chassis.SteeringWheel.Angle;

    return VehicleControlCard(
      icon: Icons.tune,
      title: 'Vehicle dynamics',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimulatedSensorSlider(signal: speed, label: 'Speed', min: 0, max: 200, unit: 'km/h'),
          SimulatedSensorSlider(
            signal: steering,
            label: 'Steering wheel angle',
            min: -90,
            max: 90,
            unit: '°',
            warnAbove: DiffLockSafetyRule.maxSteeringAngleDeg,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.check_circle, size: 16, color: Colors.greenAccent),
                label: const Text('Stopped & aligned (0 km/h, 0°)'),
                onPressed: () => simulator
                  ..report(speed, 0.0)
                  ..report(steering, 0.0),
              ),
              ActionChip(
                avatar: const Icon(Icons.speed, size: 16, color: Colors.orangeAccent),
                label: const Text('45 km/h'),
                onPressed: () => simulator.report(speed, 45.0),
              ),
              ActionChip(
                avatar: const Icon(Icons.rotate_right, size: 16, color: Colors.orangeAccent),
                label: const Text('Wheel turned 35°'),
                onPressed: () => simulator.report(steering, 35.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
