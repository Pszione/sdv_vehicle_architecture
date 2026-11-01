import 'package:flutter/material.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'widgets/battery_preconditioning_card.dart';
import 'widgets/diff_lock_control_card.dart';
import 'widgets/door_lock_control_card.dart';
import 'widgets/gear_selector_card.dart';
import 'widgets/seat_massage_control_card.dart';
import 'widgets/sunroof_control_card.dart';
import 'widgets/suspension_height_card.dart';

/// Every production control card, laid out in one or two columns depending on
/// the available width. Not scrollable: the host screen decides how to scroll.
class VehicleControlsPanel extends StatelessWidget {
  const VehicleControlsPanel({super.key});

  static const _twoColumnMinWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    final comfort = [
      const DoorLockControlCard(),
      VehicleFeatureGuard(signal: Vss.Vehicle.Cabin.Sunroof.Position, child: const SunroofControlCard()),
      // The card picks the driver seat (LHD/RHD) and hides itself without massage.
      const SeatMassageControlCard(),
    ];
    final drivetrain = [
      VehicleFeatureGuard(signal: Vss.Vehicle.Powertrain.Transmission.SelectedGear, child: const GearSelectorCard()),
      VehicleFeatureGuard(
        signal: Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked,
        child: const DiffLockControlCard(),
      ),
      VehicleFeatureGuard(signal: Vss.Vehicle.Chassis.Suspension.Height, child: const SuspensionHeightCard()),
      VehicleFeatureGuard(
        signal: Vss.Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled,
        child: const BatteryPreconditioningCard(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _twoColumnMinWidth) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...comfort, ...drivetrain]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: comfort),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: drivetrain),
            ),
          ],
        );
      },
    );
  }
}
