# infotainment

Flutter app for the **EV SUV central display**, built for tablet landscape (e.g. iPad Air 11").
Three tabs, switched from a side `NavigationRail` (bottom `NavigationBar` on phones):

| Tab | What it shows |
|---|---|
| **Vehicle** | Production controls: gear, ESC, rear diff lock, air suspension, driver assistance (ACC, lane keeping, hill descent), battery preconditioning, door locks, tailgate/frunk/charge port, sunroof, seat massage, parked modes (Dog/Camp/Sentry/V2L), Valet Mode, software update and media (locked while driving) |
| **Climate** | Full-screen 3-zone climate (driver, passenger, rear): temperature per zone, animated cabin airflow, seat heat/vent and steering wheel heat, AUTO, A/C, recirculation, max/rear defrost, SYNC, rear lock, fan and airflow. Mirrors for RHD |
| **Simulator** | Left: scenarios, simulated sensors (speed, steering, brake pedal, occupants and belts, doors, trunk, trailer, charging, SoC, temperature), sunroof fault injection and forced actuator states. Middle: the same production controls reacting live. Right: live audit log |

Every control goes through the `CommandDispatcher`. Buttons stay enabled: a blocked tap is
rejected by the safety rules (red SnackBar + orange `REJECTED` entry in the audit log), and an
orange banner warns ahead with the rule's message. Vehicle behaviors (auto-lock, auto-park...)
show up in the log under their own source, and forced states as red `FORCED` entries.

## Try it

1. Open **Simulator** and tap the *City driving* scenario (45 km/h).
2. Tap **ENGAGE LOCK** on *Rear differential lock*: rejected, "Slow down below 30 km/h…".
3. Tap *Parked & aligned* and try again: `COMMAND` then `CONFIRMED` in the audit log.
4. *City driving* also shows behaviors: `AUTO_LOCK` locks the doors at 15 km/h and, if the diff was
   locked, `AUTO_RELEASE` frees it at 40 km/h while `ESC_COORDINATOR` restores ESC.
5. *Driver leaves in DRIVE*: `AUTO_PARK` engages PARK, then `AUTO_UNLOCK` unlocks the doors.
6. *Family on board* + install update: rejected. *Ready for OTA* + install update: approved.
7. Other rules: *Highway* + open the sunroof or tailgate, *Plugged in, low battery* + DRIVE or
   preconditioning, Valet Mode + glovebox, *Crash*, *Jam at 50%* + open the sunroof,
   *Force actuator state* → diff locked at highway speed.
8. Climate: *Summer heat* + AUTO cools the cabin (Central ECU thermal model); *Lock rear* + the
   *Rear passenger panel* card is rejected; SoC 5% + fan 100% hits range protection.

## Composition root

`lib/main.dart` is the only place that knows every layer:

```dart
final container = ProviderContainer(overrides: [
  initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile), // car model
  commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
]);
container
  ..read(zonalSystemProvider)           // boot the zonal ECUs
  ..read(vehicleLoggerProvider)         // audit log
  ..read(vehicleBehaviorEngineProvider); // automatic behaviors
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
