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
| `VehicleLogger` | Ring-buffer audit log: commands, rejections, actuator changes, forced/manual states and signal faults |
| `PowerMode` + `powerModeProvider` | Power mode derived from COVESA signals (SLEEP, OFF, ACC, ON, READY, CHARGING, SW UPDATE) |
| `PowerModeAvailability` | Which functions exist in which power mode, checked before the safety rules |
| `E2eProtector` / `E2eChecker` / `E2eStateMachine` | AUTOSAR-style E2E protection (alive counter + CRC-8) |
| `E2eReceiver` + `signalStatusProvider(signal)` | Gateway side: checks frames, deadline monitoring, signal status (VALID / N/A / STALE / INVALID) |
| `FailSafe` | Shared rule answers when an input is unavailable |
| `TelltaleLogic` + `telltaleStateProvider(t)` | Cluster telltales: activation logic, bulb check |
| `DriverMessageCenter` | Cluster message queue fed by the audit log and power mode |

## Command flow

```
VehicleCommand(signal: Vss..., value: ...)
  └─▶ CommandDispatcher.dispatch
        ├─ signal in the profile?           no  → notSupportedByVehicle
        ├─ is it an actuator?               no  → readOnlySignal
        ├─ value within min/max/allowed?    no  → invalidPayload
        ├─ available in this power mode?    no  → unavailableInPowerMode (logged)
        ├─ SafetyRules whose target matches fail → rejectedBySafetyRule (logged)
        └─ CommandSink.send(command)             → approved
```

The physical confirmation arrives later, as telemetry published to the `VssBroker`.

## Safety rules

| Rule | Blocks |
|---|---|
| `DoorSafetyRule` | Locking a door that is open |
| `DoorLatchSafetyRule` | Opening a locked door by command (e-latch) |
| `SunroofSpeedSafetyRule` | Sliding the sunroof open above 120 km/h (tilt allowed) |
| `TransmissionSafetyRule` | PARK/REVERSE above 5 km/h |
| `BrakeToShiftSafetyRule` | Leaving PARK without the brake pedal |
| `DriverPresenceSafetyRule` | DRIVE/REVERSE with the driver door open or seatbelt off |
| `EvChargingSafetyRule` | Leaving PARK/NEUTRAL with the charging cable connected |
| `EvPreconditioningSafetyRule` | Battery preconditioning below 15% SoC |
| `DiffLockSafetyRule` | Locking the rear diff above 30 km/h or with the wheel turned > 15° |
| `EscModeSafetyRule` | Re-enabling ESC with the diff locked; ESC OFF above 50 km/h |
| `SuvAirSuspensionSafetyRule` | OFFROAD_MAX above 50 km/h |
| `ConvertibleTopSafetyRule` | Top with trunk open, above 50 km/h or at ≤ 0 °C |
| `OpeningWhileMovingSafetyRule` | Doors, tailgate, frunk or charge port flap above 3 km/h |
| `TowingTailgateSafetyRule` | Power tailgate with a trailer connected |
| `ChargeCableLockSafetyRule` | Releasing the cable while charging |
| `AdaptiveCruiseSafetyRule` | ACC outside DRIVE, 30–180 km/h, doors closed and driver belted |
| `SpeedWindowSafetyRule` | Lane keeping below 60 km/h; hill descent above 30 km/h |
| `ParkedModeSafetyRule` | Dog/Camp/Sentry/V2L outside PARK or below 20% SoC |
| `OtaInstallSafetyRule` | OTA unless PARK, SoC > 30%, every door locked and nobody inside |
| `ValetModeSafetyRule` | In Valet Mode: glovebox, frunk, ESC, drive mode, speeds above 80 km/h |
| `PowerModeRequestSafetyRule` | READY without key inside, brake or with the cable plugged; OFF while moving or outside PARK |
| `ReadyToShiftSafetyRule` | Leaving PARK unless READY |
| `DoorLatchSafetyRule` | Opening a locked door by command |
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
| `AutoPowerOffBehavior` (`AUTO_OFF`) | PARK, driver seat empty and driver door open → power off |
| `WalkAwayLockBehavior` (`WALK_AWAY`) | Key gone **and** car off → lock every door |
| `AutoParkingBrakeBehavior` (`AUTO_EPB`) | Parking brake follows PARK |

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
// Listen, not read: Riverpod 3 does not re-evaluate providers nobody listens to.
container.listen(vehicleBehaviorEngineProvider, (_, _) {}); // start the behaviors at boot
```

## Adding a SafetyRule

1. Implement `SafetyRule`: declare `target` (actuator), `inputs` (signals read) and `validate`.
2. Return `null` when safe and `CommandResult.rejected('reason')` otherwise. Releasing actions
   (unlock, close, disengage) are always allowed. `signals.read()` returns `null` when an input is
   missing **or not valid** (E2E): reject with a `FailSafe` answer, never default a speed to 0.
3. If the function only exists in some power modes, add it to `PowerModeAvailability` instead of
   checking the power mode in the rule.
4. Register it in `activeSafetyRulesProvider`. The rule only runs if its `target` exists in the active profile.

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
├── power/          # PowerMode, PowerModeAvailability, powerModeProvider
├── e2e/            # E2E protection, E2eReceiver, signal status
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
