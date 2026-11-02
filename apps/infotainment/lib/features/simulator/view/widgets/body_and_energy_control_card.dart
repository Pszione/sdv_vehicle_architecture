import 'package:flutter/material.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'simulated_sensor_slider.dart';
import 'simulated_sensor_switch.dart';

/// Simulated body and energy inputs: doors and tailgate by hand, charging cable, SoC and temperatures.
class BodyAndEnergyControlCard extends StatelessWidget {
  const BodyAndEnergyControlCard({super.key});

  @override
  Widget build(BuildContext context) {
    final battery = Vss.Vehicle.Powertrain.TractionBattery;

    return VehicleControlCard(
      icon: Icons.sensors,
      title: 'Body & energy sensors',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Doors and tailgate are actuators: these switches open them by hand (logged as MANUAL).
          for (final door in VehicleGroups.doors)
            SimulatedManualSwitch(signal: door.open, label: '${door.label} door open (by hand)'),
          SimulatedManualSwitch(signal: Vss.Vehicle.Body.Trunk.Rear.IsOpen, label: 'Tailgate open (by hand)'),
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
          SimulatedSensorSlider(
            signal: Vss.Vehicle.Cabin.HVAC.AmbientAirTemperature,
            label: 'Cabin temperature',
            min: -20,
            max: 60,
            unit: '°C',
          ),
        ],
      ),
    );
  }
}
