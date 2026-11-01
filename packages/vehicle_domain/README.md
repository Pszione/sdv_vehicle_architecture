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
| `SafetyRule`s | Doors, sunroof, transmission, EV charging, preconditioning, diff lock, suspension, convertible top |
| `VehicleLogger` | Ring-buffer audit log: commands, rejections and actuator changes |

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

## Providers the app must override

```dart
ProviderContainer(overrides: [
  initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
  commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
]);
```

## Adding a SafetyRule

1. Implement `SafetyRule`: declare `target` (actuator), `inputs` (signals read) and `validate`.
2. Return `null` when safe and `CommandResult.rejected('reason')` otherwise. Releasing actions
   (unlock, close, disengage) are always allowed. Document what happens when an input is missing.
3. Register it in `activeSafetyRulesProvider`. The rule only runs if its `target` exists in the active profile.

## Adding signals

Edit `lib/src/vss/vehicle.vss.json` following the latest COVESA VSS naming and run
`dart run build_runner build`. Never edit `*.g.dart`.

## Structure

```
lib/src/
├── vss/            # vehicle.vss.json (master spec), VssSignal, generated tree
├── profile/        # VehicleProfile, active profile, isSignalSupported
├── broker/         # VssBroker, vssValueProvider, SignalReader
├── dispatcher/     # CommandDispatcher, CommandValidator, CommandSink, canDispatch
├── safety_rules/   # SafetyRule + implementations + activeSafetyRulesProvider
└── logger/         # VehicleLogger (audit log)
```

## Tests

```
dart test
```
