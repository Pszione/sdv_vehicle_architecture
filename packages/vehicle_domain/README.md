# vehicle_domain

**Layer 2: Intelligence & rules.** Pure Dart. Owns the signal contract (master VSS spec),
the confirmed vehicle state, the command pipeline and the safety rules.
**It does not know the E/E topology**: approved commands leave through an interface (`CommandSink`).

## Components

| Component | Role |
|---|---|
| `Vss` / `vssCatalog` | Typed API generated from `lib/src/vss/vehicle.vss.json` |
| `VehicleProfile` + `activeVehicleProfileProvider` | Which signals exist in the active model (LHD/RHD, overrides) |
| `VssBroker` | Latest confirmed value of every signal. Only ECUs and simulators publish |
| `vssValueProvider(signal)` | Granular read: only notifies when that signal changes |
| `CommandDispatcher` | Single entry point for commands: validates, logs and sends to the `CommandSink` |
| `CommandValidator` | Pure pipeline: capability → actuator → spec range → `SafetyRule`s |
| `canDispatchProvider(command)` | Reactive dry run, used to warn before the user taps |
| `SafetyRule`s | Gate commands: "can this run now?" (see table below) |
| `VehicleBehavior`s + `VehicleBehaviorEngine` | React to state: "what should the car do on its own?" Issue commands through the dispatcher |
| `hmiLockoutReasonProvider(feature)` | HMI policy: video playback and keyboard input locked above 8 km/h |
| `VehicleGroups` | Shared signal groups: doors, seats, HVAC stations (front/rear), driver door/seat |
| `VehicleLogger` | Ring-buffer audit log: commands, rejections, actuator changes and forced states |

## Command flow

```
VehicleCommand(signal: Vss..., value: ...)
  └─▶ CommandDispatcher.dispatch
        ├─ signal in the profile?           no  → notSupportedByVehicle
        ├─ is it an actuator?               no  → readOnlySignal
        ├─ value within min/max/allowed?    no  → invalidPayload
        ├─ SafetyRules whose target matches fail → rejectedBySafetyRule (logged)
        └─ CommandSink.send(command)             → approved
```

The physical confirmation arrives later, as telemetry published to the `VssBroker`.

## Safety rules

| Rule | Blocks |
|---|---|
| `DoorSafetyRule` | Locking a door that is open |
| `SunroofSpeedSafetyRule` | Opening the sunroof above 120 km/h |
| `TransmissionSafetyRule` | PARK/REVERSE above 5 km/h |
| `BrakeToShiftSafetyRule` | Leaving PARK without the brake pedal |
| `DriverPresenceSafetyRule` | DRIVE/REVERSE with the driver door open or seatbelt off |
| `EvChargingSafetyRule` | Leaving PARK/NEUTRAL with the charging cable connected |
| `EvPreconditioningSafetyRule` | Battery preconditioning below 15% SoC |
| `DiffLockSafetyRule` | Locking the rear diff above 30 km/h or with the wheel turned > 15° |
| `EscModeSafetyRule` | Re-enabling ESC with the diff locked; ESC OFF above 50 km/h |
| `SuvAirSuspensionSafetyRule` | OFFROAD_MAX above 50 km/h |
| `ConvertibleTopSafetyRule` | Top with trunk open, above 50 km/h or at ≤ 0 °C |
| `OpeningWhileMovingSafetyRule` | Tailgate, frunk or charge port flap above 3 km/h |
| `TowingTailgateSafetyRule` | Power tailgate with a trailer connected |
| `ChargeCableLockSafetyRule` | Releasing the cable while charging |
| `AdaptiveCruiseSafetyRule` | ACC outside DRIVE, 30–180 km/h, doors closed and driver belted |
| `SpeedWindowSafetyRule` | Lane keeping below 60 km/h; hill descent above 30 km/h |
| `ParkedModeSafetyRule` | Dog/Camp/Sentry/V2L outside PARK or below 20% SoC |
| `OtaInstallSafetyRule` | OTA unless PARK, SoC > 30%, every door locked and nobody inside |
| `ValetModeSafetyRule` | In Valet Mode: glovebox, frunk, ESC, drive mode, speeds above 80 km/h |
| `RearClimateLockSafetyRule` | Rear-panel (`REAR_PANEL`) climate changes while the front locked them |
| `ClimateRangeProtectionSafetyRule` | Fan above 50% below 10% SoC |

## Vehicle behaviors

| Behavior (audit-log source) | Trigger → action |
|---|---|
| `SpeedAutoLockBehavior` (`AUTO_LOCK`) | Speed crosses 15 km/h → lock every unlocked door |
| `ParkAutoUnlockBehavior` (`AUTO_UNLOCK`) | Gear becomes PARK → unlock every door |
| `DiffLockAutoReleaseBehavior` (`AUTO_RELEASE`) | Speed crosses 40 km/h with the diff locked → release it |
| `DiffLockEscBehavior` (`ESC_COORDINATOR`) | Diff locked → ESC OFF; diff released → restore the previous ESC mode |
| `AutoParkBehavior` (`AUTO_PARK`) | DRIVE/REVERSE, ≤ 3 km/h, driver door open and unbelted → PARK |
| `SuspensionAutoLevelBehavior` (`AUTO_LEVEL`) | Above 110 km/h → LOW; below 80 km/h → back to NORMAL |
| `CrashResponseBehavior` (`CRASH_RESPONSE`) | Crash detected → unlock every door, hazards on |
| `ValetSpeedCapBehavior` (`VALET`) | Valet Mode on → speed limiter at 80 km/h |
| `ClimateSyncBehavior` (`CLIMATE_SYNC`) | SYNC on → the other stations follow the driver temperature |
| `MaxDefrostBehavior` (`DEFROST`) | Front defrost on → A/C on, fresh air, front airflow UP, fan ≥ 70% |
| `EmptySeatClimateBehavior` (`SEAT_CLIMATE`) | Seat becomes EMPTY → its heating/ventilation off |

Behaviors never write to the broker: their commands go through the dispatcher, so the
safety rules still apply (an auto-lock on an open door is rejected and logged). The engine
dispatches on the next cycle (microtask), never from inside a broker notification, and
ignores the full state reset caused by a profile switch.

## Providers the app must override

```dart
ProviderContainer(overrides: [
  initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
  commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
]);
container.read(vehicleBehaviorEngineProvider); // start the behaviors at boot
```

## Adding a SafetyRule

1. Implement `SafetyRule`: declare `target` (actuator), `inputs` (signals read) and `validate`.
2. Return `null` when safe and `CommandResult.rejected('reason')` otherwise. Releasing actions
   (unlock, close, disengage) are always allowed. Document what happens when an input is missing.
3. Register it in `activeSafetyRulesProvider`. The rule only runs if its `target` exists in the active profile.

## Adding a VehicleBehavior

1. Implement `VehicleBehavior`: declare `triggers` and return commands from `react(before, after)`,
   each with a `source` naming the behavior. Use `crossedAbove`/`becameEqual` to react to edges, not levels.
2. Register it in `activeVehicleBehaviorsProvider`.

## Adding signals

Edit `lib/src/vss/vehicle.vss.json` following the latest COVESA VSS naming and run
`dart run build_runner build`. Never edit `*.g.dart`.

## Structure

```
lib/src/
├── vss/            # vehicle.vss.json (master spec), VssSignal, value constants, generated tree
├── profile/        # VehicleProfile, active profile, isSignalSupported, VehicleGroups
├── broker/         # VssBroker, vssValueProvider, SignalReader
├── dispatcher/     # CommandDispatcher, CommandValidator, CommandSink, canDispatch
├── safety_rules/   # SafetyRule + implementations + activeSafetyRulesProvider
├── behaviors/      # VehicleBehavior + implementations + VehicleBehaviorEngine
├── hmi/            # HMI lockouts while driving
└── logger/         # VehicleLogger (audit log)
```

## Tests

```
dart test
```
