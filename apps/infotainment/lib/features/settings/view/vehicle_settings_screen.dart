import 'package:flutter/material.dart';

class VehicleSettingsScreen extends StatelessWidget {
  const VehicleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Sempre visível em qualquer versão
        const DoorLockControlCard(),

        // Renderizado APENAS se a versão do carro tiver Teto Solar
        VehicleFeatureGuard(
          vssPath: Vss.Vehicle.Cabin.Sunroof.Position,
          child: const SunroofControlCard(),
        ),

        // Renderizado APENAS se a versão tiver Banco com Massagem
        VehicleFeatureGuard(
          vssPath: Vss.Vehicle.Seat.Row1.Left.Massage.Mode,
          child: const SeatMassageControlCard(),
        ),
      ],
    );
  }
}