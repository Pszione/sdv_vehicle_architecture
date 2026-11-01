import 'package:flutter/material.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'simulated_sensor_switch.dart';

/// Simulated seat occupancy and seatbelt sensors.
class OccupantsControlCard extends StatelessWidget {
  const OccupantsControlCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VehicleControlCard(
      icon: Icons.airline_seat_recline_normal,
      title: 'Occupants',
      child: Column(
        children: [
          for (final seat in VehicleGroups.seats)
            Row(
              children: [
                Expanded(
                  child: SimulatedSensorSwitch(signal: seat.occupied, label: '${seat.label} seated'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SimulatedSensorSwitch(signal: seat.belted, label: 'Belted'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
