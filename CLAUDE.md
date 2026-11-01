# CLAUDE.md

Software-Defined Vehicle (SDV) simulation for a luxury EV, in Flutter/Dart.
Pure-Dart "vehicle brain" (signal broker, safety rules, zonal controllers)
driving two Flutter HMIs. Inspired by COVESA VSS / Eclipse SDV zonal architectures.

## Stack
- Dart SDK ^3.10 (dot shorthands like `.center` are allowed), Flutter.
- Riverpod 3 with codegen (`@riverpod`, `Notifier`, `AsyncNotifier`).
  Use `.select()` for widgets bound to high-frequency signals (cluster runs at 60 FPS).
- `build_runner` for Riverpod and VSS code generation.
- Melos is the intended monorepo tool (no `melos.yaml` yet).

## Layout
```
apps/
  infotainment/      Center display: HVAC, media, vehicle settings. Composes the ProviderScope
                     (active profile + safety-rule overrides per vehicle model).
  digital_cluster/   Instrument cluster: speed, ADAS rendering. (Still the Flutter template.)
packages/
  vss_gen/           Builder: VSS JSON spec -> typed `Vss.Vehicle...` path getters.
                     Spec: lib/src/vss_spec_luxury.json. Generator: lib/tools/vss_generator.dart.
  vehicle_domain/    Business rules: VehicleCommand/CommandResult, SafetyRule implementations,
                     CommandDispatcher (validate -> route -> emit), VehicleLogger (ring-buffer audit log).
  vehicle_profiles/  Trims/capabilities (VehicleProfile, ActiveVehicleProfile). Drives feature gating.
  zonal_system/      Simulation engine: ZonalCommandBus, zone controllers (Top, West, ...),
                     "dumb" actuators with fault injection. VssBroker belongs here (not written yet).
  vehicle_ui_kit/    Shared widgets (CarProfileSelectorBar; VehicleFeatureGuard should move here).
```

## Command flow (the core invariant)
UI -> `CommandDispatcher.dispatch(VehicleCommand)`
  1. capability check (`isSignalSupportedProvider(path)` from the active profile)
  2. every rule in `activeSafetyRulesProvider` (first rejection wins, logged)
  3. resolve zone + deviceId -> `ZonalCommand` on `ZonalCommandBus`
Zone controller -> actuator -> writes the *confirmed* value to the VssBroker.
UI reads state only from the broker, never from the command it sent.
`evaluate()` / `canDispatchProvider` is the dry run used to enable/disable controls.

## Conventions
- Never hardcode VSS strings: use generated `Vss.Vehicle...` getters.
- A `SafetyRule` returns `null` for "not my concern / safe" and `CommandResult.rejected(msg)` otherwise.
  Rules first check their target path and payload, then capability (skip if unsupported).
  Releasing actions (unlock, close, disengage) are always allowed.
- Per-model behaviour is added through `ProviderScope` overrides in the app, not `if (model == ...)` in packages.
- Domain packages stay Flutter-free where possible; widgets only in apps and `vehicle_ui_kit`.
- File = one class or provider; features under `lib/src/<feature>/{domain,providers}`; packages export via a barrel file.
- Code comments and user-facing strings are in pt-BR.
- Use a logger instead of `print`. Generated `*.g.dart` files are never edited by hand.

## Commands (per package until Melos is set up)
```
dart run build_runner build --delete-conflicting-outputs   # Riverpod + VSS codegen
flutter analyze
flutter test
```

## Tests
Few, focused on main logic (safety rules, dispatcher pipeline, actuator state machine, generator output).
Name tests `should <result> when <condition>`. Use a real `ProviderContainer` with overrides;
don't assert on values a mock was told to return ("mock echo"). Avoid editing existing tests unless broken.

## Current state (early scaffold, does not compile yet)
- Missing: VssBroker (`vssBrokerProvider`, `vssSignalProvider`, `isSignalSupportedProvider`),
  `TransmissionSafetyRule`, `DumbDoorActuator`, `evSuvProfile`, `EvSuvApp`, the control cards,
  Riverpod/build deps in package pubspecs, real barrel exports (still the `Calculator` template), imports.
- Root `build.yaml` is a placeholder (`your_app_name`); the builder config belongs in `packages/vss_gen/build.yaml`.
- The VSS generator names classes by leaf key (`_VssRow1`, `_VssLeft`...), which collides across branches.
