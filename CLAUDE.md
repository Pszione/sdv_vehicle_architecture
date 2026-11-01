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
                    profile, VssBroker, CommandDispatcher/CommandValidator, SafetyRules, VehicleLogger.
                    Knows nothing about zones: approved commands go to the CommandSink interface.
  vehicle_profiles/ pure Dart -> domain. Factory trims as lib/src/profiles/*.profile.json.
  zonal_system/     pure Dart -> domain. ZonalCommandBus (plain stream), ZonalRoute table,
                    ZonalCommandSink, zone ECUs (Top, Door west/east, Generic south/central), actuators.
  vehicle_simulators/ pure Dart -> domain. TelemetrySimulator + SimulationScenario presets (fake sensors).
  vehicle_ui_kit/   Flutter -> domain. VehicleFeatureGuard, SafetyPrecheckBanner, VehicleControlCard,
                    WidgetRef.watchSignal/dispatchCommand.
apps/
  infotainment/     composition root in main.dart; Vehicle tab (production cards) and
                    Simulator tab (sensors | reactive cards | audit log). Targets iPad landscape.
  digital_cluster/  still the Flutter template.
```

## Command flow (core invariant)
UI -> `ref.dispatchCommand(context, VehicleCommand(signal: Vss..., value: ...))`
-> `CommandValidator`: signal in profile -> is actuator -> value within spec min/max/allowed
-> every `SafetyRule` whose `target` is the signal (first rejection wins, logged)
-> `CommandSink` (app wires `ZonalCommandSink`) -> `ZonalRoute` -> bus -> zone ECU -> actuator
-> ECU publishes the *confirmed* value to `VssBroker`. UI reads only the broker, never the command.
Only zonal ECUs and `TelemetrySimulator` publish telemetry; widgets never write to the broker.
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
- SafetyRule: declare `target` and `inputs`, read via `SignalReader`, return `null` when safe.
  Releasing actions (unlock, close, disengage) are always allowed. State the fallback when an input is missing.
- Widgets watch single signals (`ref.watchSignal`), never the whole broker map; use `.select` on profile fields.
- Long-lived infrastructure (broker, bus, ECUs, logger, dispatcher) is `keepAlive` and booted in `main.dart`.
- Per-model behaviour: profiles or `ProviderScope` overrides, never `if (model == ...)` in packages.
- No `print` (use `dart:developer` `log`). Never edit `*.g.dart`.
- **Everything in English**: docs (READMEs, CLAUDE.md), dartdoc/comments, UI text and rule messages.
- Formatter page width 120.

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
- Spec paths keep the original project naming; several differ from official VSS 5
  (e.g. `Vehicle.Cabin.Seat.Row1.DriverSide`, `Door...IsOpen`, `SelectedGear` int8).
- Switching profile resets the broker but not the actuators' internal state.
- digital_cluster and the 30 Hz ADAS simulator are not wired yet.
