import 'package:flutter/material.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'widgets/door_lock_control_card.dart';
import 'widgets/seat_massage_control_card.dart';
import 'widgets/sunroof_control_card.dart';

class VehicleSettingsScreen extends StatelessWidget {
  const VehicleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Presente em todas as versões.
        const DoorLockControlCard(),

        // Só nas versões com teto solar.
        VehicleFeatureGuard(signal: Vss.Vehicle.Cabin.Sunroof.Position, child: const SunroofControlCard()),

        // O próprio card escolhe o banco do motorista (LHD/RHD) e some se não houver massagem.
        const SeatMassageControlCard(),
      ],
    );
  }
}
