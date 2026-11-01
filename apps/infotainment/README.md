# infotainment

App Flutter da **central multimídia do EV SUV**: configurações do veículo
(travas, teto solar, massagem dos bancos) controladas pelo `CommandDispatcher`.

## Composition root

`lib/main.dart` é o único lugar que conhece todas as camadas:

```dart
final container = ProviderContainer(overrides: [
  initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile), // modelo do carro
  commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
]);
container
  ..read(zonalSystemProvider)   // boot das ECUs zonais
  ..read(vehicleLoggerProvider); // audit log
```

Para outro modelo (ex: um sedan), basta outro app ou flavor com outro perfil no override.
Nenhum pacote muda.

## Estrutura

```
lib/
├── main.dart                         # Composition root
├── app/ev_suv_app.dart               # MaterialApp + seletor de perfil
├── core/command_source.dart          # Origem "INFOTAINMENT_UI" no audit log
└── features/settings/view/
    ├── vehicle_settings_screen.dart  # Lista de cards protegidos por VehicleFeatureGuard
    └── widgets/                      # DoorLock, Sunroof, SeatMassage cards
```

## Rodar

```
flutter run              # escolha o dispositivo
flutter test
```

iOS: deployment target 15.0 e ciclo de vida UIScene (`FlutterSceneDelegate`).
