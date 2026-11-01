# infotainment

Flutter app for the **EV SUV central display**, built for tablet landscape (e.g. iPad Air 11").
Two tabs, switched from a side `NavigationRail` (bottom `NavigationBar` on phones):

| Tab | What it shows |
|---|---|
| **Vehicle** | Production controls: door locks, sunroof, seat massage, gear selector, rear diff lock, air suspension, battery preconditioning |
| **Simulator** | Left: simulated sensors (speed, steering, doors, trunk, charging cable, SoC, temperature), scenarios and sunroof fault injection. Middle: the same production controls reacting live. Right: live audit log |

Every control goes through the `CommandDispatcher`. Buttons stay enabled: a blocked tap is
rejected by the safety rules (red SnackBar + `REJECTED` entry in the audit log), and an
orange banner warns ahead with the rule's message.

## Try it

1. Open **Simulator** and tap the *City driving* scenario (45 km/h).
2. Tap **ENGAGE LOCK** on *Rear differential lock*: rejected, "Slow down below 30 km/h…".
3. Tap *Parked & aligned* and try again: `COMMAND` then `CONFIRMED` in the audit log.
4. Other rules: *Highway* + open the sunroof, *Plugged in, low battery* + D gear or preconditioning,
   *Driver door open* + lock the front left door, *Jam at 50%* + open the sunroof.

## Composition root

`lib/main.dart` is the only place that knows every layer:

```dart
final container = ProviderContainer(overrides: [
  initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile), // car model
  commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
]);
container
  ..read(zonalSystemProvider)   // boot the zonal ECUs
  ..read(vehicleLoggerProvider); // audit log
```

For another model (e.g. a sedan), create another app or flavor with a different profile
in the override. No package changes.

## Structure

```
lib/
├── main.dart                         # Composition root
├── app/
│   ├── ev_suv_app.dart               # MaterialApp (dark theme)
│   └── home_shell.dart               # Profile bar + NavigationRail (Vehicle | Simulator)
├── core/command_source.dart          # "INFOTAINMENT_UI" source in the audit log
└── features/
    ├── settings/view/
    │   ├── vehicle_settings_screen.dart  # Vehicle tab
    │   ├── vehicle_controls_panel.dart   # Responsive 1/2-column panel of production cards
    │   └── widgets/                      # One card per feature/rule
    └── simulator/view/
        ├── simulator_screen.dart         # Simulator tab (3 columns on wide screens)
        └── widgets/                      # Sensor sliders/switches, scenarios, faults, audit log
```

## Run

```
flutter run              # pick the device
flutter test
```

iOS: deployment target 15.0 and UIScene lifecycle (`FlutterSceneDelegate`).
