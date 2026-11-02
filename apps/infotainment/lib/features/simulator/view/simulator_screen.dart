import 'package:flutter/material.dart';

import '../../settings/view/vehicle_controls_panel.dart';
import 'widgets/audit_log_panel.dart';
import 'widgets/body_and_energy_control_card.dart';
import 'widgets/fault_injection_card.dart';
import 'widgets/force_actuator_card.dart';
import 'widgets/key_and_power_card.dart';
import 'widgets/occupants_control_card.dart';
import 'widgets/rear_passenger_panel_card.dart';
import 'widgets/scenario_presets_card.dart';
import 'widgets/vehicle_dynamics_control_card.dart';

/// "Simulator" tab: change the simulated world on the left, watch the production
/// controls react in the middle and the dispatcher's decisions on the right.
class SimulatorScreen extends StatelessWidget {
  const SimulatorScreen({super.key});

  static const _threeColumnMinWidth = 1000.0;

  @override
  Widget build(BuildContext context) {
    const world = [
      _SectionTitle('Simulated world (sensors)'),
      ScenarioPresetsCard(),
      KeyAndPowerCard(),
      VehicleDynamicsControlCard(),
      OccupantsControlCard(),
      RearPassengerPanelCard(),
      BodyAndEnergyControlCard(),
      FaultInjectionCard(),
      ForceActuatorCard(),
    ];
    const reactiveControls = [_SectionTitle('Infotainment controls (reactive)'), VehicleControlsPanel()];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _threeColumnMinWidth) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: const [
              ...world,
              ...reactiveControls,
              SizedBox(height: 420, child: AuditLogPanel()),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ListView(padding: const EdgeInsets.all(8), children: world),
            ),
            Expanded(
              flex: 4,
              child: ListView(padding: const EdgeInsets.all(8), children: reactiveControls),
            ),
            const Expanded(
              flex: 3,
              child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: AuditLogPanel()),
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white54, letterSpacing: 1.2),
      ),
    );
  }
}
