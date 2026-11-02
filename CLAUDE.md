# CLAUDE.md

Software-Defined Vehicle (SDV) simulation for a luxury EV, in Flutter/Dart.
Pure-Dart "vehicle brain" (VSS broker, dispatcher, safety rules, zonal ECUs)
driving Flutter HMIs. Inspired by COVESA VSS / Eclipse SDV zonal architectures.

## Stack
- Dart SDK ^3.10 (dot shorthands like `.center` are fine), Flutter.
- Riverpod 3 + riverpod_generator (`@riverpod`, `@Riverpod(keepAlive: true)`).
  `select` needs `import 'package:riverpod/riverpod.dart'` (not re-exported by riverpod_annotation).
- Pub workspace + Melos 8 (config lives in the root `pubspec.yaml`, no `melos.yaml`).
- Versions are whatever pub resolves against the installed Flutter SDK; don't hand-pin.

## Layout and dependency graph
```
packages/
  vss_gen/          builders only (dev_dependency). vss_tree: *.vss.json -> Vss tree + vssCatalog.
                    vss_profile: *.profile.json -> const VehicleProfile, validated against the spec.
  vehicle_domain/   pure Dart. Master spec lib/src/vss/vehicle.vss.json, VehicleProfile + active
                    profile, VssBroker, CommandDispatcher/CommandValidator, SafetyRules, VehicleLogger,
                    power/ (PowerMode derived from COVESA signals, PowerModeAvailability),
                    e2e/ (E2E protection, E2eReceiver gateway, signal status), hmi/ (lockouts,
                    cluster telltales, DriverMessageCenter).
                    Knows nothing about zones: approved commands go to the CommandSink interface.
  vehicle_profiles/ pure Dart -> domain. Factory trims as lib/src/profiles/*.profile.json.
  zonal_system/     pure Dart -> domain. ZonalCommandBus (plain stream), ZonalRoute table,
                    ZonalCommandSink, zone ECUs: West/East (BodySideEcu: doors, shades, seats of that
                    physical side, LHD/RHD aware) and Central (sunroof, HVAC + CabinThermalModel, gateway
                    echo for domain ECUs: powertrain, chassis, ADAS). No other zones.
                    power/: VehicleModeManager (12 V state, HV pre-charge, sleep, 12 V model) and
                    ZoneNetworkManagement (bus sleep, wake-up latency for commands).
  vehicle_simulators/ pure Dart -> domain. TelemetrySimulator: report() sensors, command() actuators via
                    the dispatcher, operateManually() for by-hand actuators (doors, logged MANUAL),
                    forceActuatorState() bypasses rules (logged FORCED). Scenarios = steps (can wait).
                    Protected sensors go through E2eTransmitter (faults injectable). DrivingSimulator:
                    30 Hz drive (ACC, lead car, lanes, power, odometer).
  vehicle_ui_kit/   Flutter -> domain. VehicleFeatureGuard, SafetyPrecheckBanner, VehicleControlCard,
                    PowerModeChip, WidgetRef.watchSignal/watchSignalStatus/dispatchCommand.
apps/
  infotainment/     composition root in main.dart; Vehicle tab (production cards), Climate tab
                    (full-screen 3-zone HVAC, rail stays visible) and Simulator tab
                    (sensors | reactive cards | audit log). Targets iPad Air 11" landscape.
  digital_cluster/  read-only Tesla/Rivian-style cluster (iPad landscape), standalone vehicle core +
                    dev/DemoDriveBar until the IPC bridge exists (docs/ipc-bridge.md).
```

## Command flow (core invariant)
UI -> `ref.dispatchCommand(context, VehicleCommand(signal: Vss..., value: ...))`
-> `CommandValidator`: signal in profile -> is actuator -> value within spec min/max/allowed
-> available in the current power mode (`PowerModeAvailability`) -> every `SafetyRule` whose `target` is the signal (first rejection wins, logged)
-> `CommandSink` (app wires `ZonalCommandSink`) -> `ZonalRoute` -> bus -> zone ECU -> actuator
-> ECU publishes the *confirmed* value to `VssBroker`. UI reads only the broker, never the command.
Only zonal ECUs, the `E2eReceiver` and `TelemetrySimulator` publish telemetry; widgets never write to the broker.
E2E-protected sensors (`E2eProtectedSignals`) reach the broker only through the `E2eReceiver`;
`SignalReader.read()` returns `null` unless their status is VALID, so rules must fail safe (`FailSafe`).
`VehicleBehavior`s (auto-lock, auto-park...) react to broker changes and issue commands through the
dispatcher on the next cycle (`VehicleBehaviorEngine`), so rules always apply. HMI lockouts
(`hmiLockoutReasonProvider`) are UI policy, not commands.
`canDispatchProvider(command)` is the dry run; it re-evaluates only when a rule's `inputs` change.
Controls stay enabled: `SafetyPrecheckBanner` warns ahead, the dispatcher has the final word.

## Model variants (no compile errors per model)
One master spec = union of all signals, so all code compiles for every model.
A profile lists the signals a model has (+ min/max/allowed overrides, driverSide).
Unknown paths in a profile fail the build. At runtime the active profile gates
the UI (VehicleFeatureGuard), the dispatcher (notSupported) and the broker.

## Conventions
- Never hardcode VSS strings: use `Vss.Vehicle...` (const `VssSignal<T>`). New signals: edit
  `vehicle.vss.json` (official vss-tools JSON shape, follow the latest COVESA VSS naming), rebuild.
- Seats/doors use COVESA `DriverSide`/`PassengerSide`, HVAC stations `Driver`/`Passenger`: logical, so
  LHD/RHD never changes the path. `ZonalRoute` maps them to the physical west/east zone.
- String signal values come from `vss_values.dart` (`Gear.park`, `SeatOccupancy.empty`...); door/seat/HVAC
  station groups and the driver door/seat from `VehicleGroups`.
- SafetyRule: declare `target` and `inputs`, read via `SignalReader`, return `null` when safe.
  Releasing actions (unlock, close, disengage) are always allowed. State the fallback when an input is missing.
- Widgets watch single signals (`ref.watchSignal`), never the whole broker map; use `.select` on profile fields.
- Long-lived infrastructure (broker, bus, ECUs, logger, dispatcher) is `keepAlive` and booted in `main.dart`.
- Per-model behaviour: profiles or `ProviderScope` overrides, never `if (model == ...)` in packages.
- No `print` (use `dart:developer` `log`). Never edit `*.g.dart`.
- **Everything in English**: docs (READMEs, CLAUDE.md), dartdoc/comments, UI text and rule messages.
- Formatter page width 120.
- Boot with `container.listen(provider, (_, _) {})`, not `read`: Riverpod 3 does not re-evaluate
  providers nobody listens to, so an ECU's own `ref.listen`s would stay silent. In a Notifier's
  `build`, never `ref.read` an autoDispose provider (it schedules a disposal on the provider
  scheduler and stalls widget tests); read the keepAlive profile instead.
- Periodic timers (cyclic E2E sends, deadline monitoring) start from explicit `start...()` calls at
  boot, never in `build`, so widget tests leave no pending timer.
- Spec `default`s are the simulated car's boot snapshot (driver seated with the key, ignition ON, P).
- Custom (non-COVESA) signals say `Custom (not in COVESA VSS).` in their description.
- Feature docs live in `docs/` and end with "Gaps vs. a production ECU".

## Commands
```
dart run melos run generate      # build_runner in every package, topological order
dart run melos run analyze
dart run melos run test:dart     # pure Dart packages
dart run melos run test:flutter  # ui_kit + apps
```
build_runner 2.15 ignores `--delete-conflicting-outputs`; plain `build` is enough.
Commit generated files (`build_to: source`).

## Tests
Few, focused on main logic. Name them `should <result> when <condition>`.
Use `ProviderContainer.test` with overrides; Riverpod 3 flushes listeners async (`await container.pump()`).
Capture outputs with a recording fake (e.g. a `CommandSink` that stores commands), don't assert on
values a mock was told to return. Avoid editing existing tests unless broken.

## Known gaps
- COVESA-typed: `Sunroof.Position` int8 % (-100 tilt..100, profiles set `min: 0` when slide-only),
  `SelectedGear` int8 (`Gear.park` 126, `drive` 127, `neutral` 0, `reverse` -1; the gear set comes from the
  profile `allowed` override), `Door.IsOpen` and `Trunk.Rear.IsOpen` are actuators (opened by hand via the
  simulator's `operateManually`). Custom: `HVAC.IsAutoActive/IsSyncActive/IsRearControlLocked`,
  `Door.SoftCloseState`. Row2 middle seat not modeled.
- Switching profile resets the broker but not the actuators' internal state.
- The cluster runs its own vehicle core (standalone); the IPC bridge is designed, not built.
- Each docs/ guide lists its gaps vs. a production ECU (power modes, E2E, cluster).
