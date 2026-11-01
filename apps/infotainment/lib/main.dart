import 'package:flutter/material.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        activeVehicleProfileProvider.overrideWith((ref) => evSuvProfile),
        activeSafetyRulesProvider.overrideWith(
          (ref) => [
            ...ref.watch(activeSafetyRulesProvider), // Regras Padrão
            DiffLockSafetyRule(), // Regras 4x4
            EvChargingSafetyRule(), // Regras de EV
            EvPreconditioningSafetyRule(),
          ],
        ),
      ],
      child: const EvSuvApp(),
    ),
  );
}
