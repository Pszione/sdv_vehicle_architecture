import 'package:flutter/material.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'simulated_sensor_slider.dart';
import 'simulated_sensor_switch.dart';

/// Simulated body and energy sensors: doors, trunk, charging cable, SoC and outside temperature.
class BodyAndEnergyControlCard extends StatelessWidget {
  const BodyAndEnergyControlCard({super.key});

  @override
  Widget build(BuildContext context) {
    final door = Vss.Vehicle.Cabin.Door;
    final battery = Vss.Vehicle.Powertrain.TractionBattery;

    return VehicleControlCard(
      icon: Icons.sensors,
      title: 'Body & energy sensors',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimulatedSensorSwitch(signal: door.Row1.Left.IsAjar, label: 'Front left door open'),
          SimulatedSensorSwitch(signal: door.Row1.Right.IsAjar, label: 'Front right door open'),
          SimulatedSensorSwitch(signal: door.Row2.Left.IsAjar, label: 'Rear left door open'),
          SimulatedSensorSwitch(signal: door.Row2.Right.IsAjar, label: 'Rear right door open'),
          SimulatedSensorSwitch(signal: Vss.Vehicle.Body.Trunk.IsAjar, label: 'Trunk open'),
          SimulatedSensorSwitch(signal: Vss.Vehicle.Body.Trailer.IsConnected, label: 'Trailer connected'),
          SimulatedSensorSwitch(signal: battery.Charging.IsConnected, label: 'Charging cable connected'),
          SimulatedSensorSwitch(signal: battery.Charging.IsCharging, label: 'Charging in progress'),
          const SizedBox(height: 8),
          SimulatedSensorSlider(signal: battery.StateOfCharge, label: 'State of charge', min: 0, max: 100, unit: '%'),
          SimulatedSensorSlider(
            signal: Vss.Vehicle.Exterior.AirTemperature,
            label: 'Outside temperature',
            min: -20,
            max: 45,
            unit: '°C',
          ),
        ],
      ),
    );
  }
}
