import 'package:flutter/material.dart';

import 'vehicle_controls_panel.dart';

/// "Vehicle" tab: the production controls of the car.
class VehicleSettingsScreen extends StatelessWidget {
  const VehicleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(padding: EdgeInsets.all(8), child: VehicleControlsPanel());
  }
}
