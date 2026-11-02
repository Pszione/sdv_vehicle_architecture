# SDV Vehicle Architecture

Software ecosystem for a **luxury software-defined electric vehicle (SDV)**, built with
Flutter/Dart. The car's "brain" (VSS signals, safety rules, zonal ECUs and actuators) is
pure Dart; the HMIs are Flutter apps that only send commands and display telemetry.

Inspired by architectures such as Rivian, Tesla and Porsche and by COVESA / Eclipse SDV concepts.

**Stack:** Dart 3.10 · Flutter 3.38 · Riverpod 3 (codegen) · Melos 8 (pub workspace) ·
`build_runner` · COVESA VSS (Vehicle Signal Specification)

## Monorepo structure

```text
sdv_vehicle_architecture/
│
├── pubspec.yaml                                    # Pub workspace + Melos scripts
├── analysis_options.yaml                           # Shared lints (pure Dart packages)
├── CLAUDE.md                                       # Architecture guide for AI agents
│
├── apps/                                           # FINAL APPLICATIONS (Executables)
│   ├── infotainment/                               # Flutter app for the EV SUV central display
│   │   ├── lib/
│   │   │   ├── main.dart                           # Composition root: profile + zonal bus
│   │   │   ├── app/                                # MaterialApp + NavigationRail shell
│   │   │   └── features/
│   │   │       ├── settings/                       # Vehicle tab (Gear, ESC, 4x4, ADAS, OTA, Valet...)
│   │   │       ├── climate/                        # Climate tab (3-zone HVAC, seat/wheel heat, airflow)
│   │   │       └── simulator/                      # Simulator tab (sensors, scenarios, audit log)
│   │   └── pubspec.yaml                            # Depends on the domain/zonal/sim/UI packages
│   │
│   └── digital_cluster/                            # Flutter app for the Instrument Cluster (Tesla/Rivian style)
│       ├── lib/
│       │   ├── main.dart                           # Composition root (standalone vehicle core)
│       │   ├── core/                               # Palette, 30 Hz -> 60 FPS interpolation
│       │   ├── dev/                                # Standalone demo inputs
│       │   └── features/cluster/                   # Telltales, speed, PRND, ADAS view, messages
│       └── pubspec.yaml
│
├── docs/                                           # Feature guides: benefits, design, gaps vs. a real ECU
│   ├── power-modes.md                              # Vehicle mode manager, network management, 12 V
│   ├── e2e-signal-protection.md                    # AUTOSAR-style E2E, signal status, fail-safe rules
│   ├── digital-cluster.md                          # Cluster design and rendering budget
│   └── ipc-bridge.md                               # Design: sharing one vehicle core between HMIs
│
└── packages/                                       # REUSABLE DOMAIN MODULES
    │
    ├── vss_gen/                                    # [1. VSS SIGNAL LAYER]
    │   ├── lib/
    │   │   ├── src/
    │   │   │   ├── vss_spec.dart                   # VSS spec parser + validation (vss-tools JSON)
    │   │   │   ├── vss_tree_builder.dart           # *.vss.json -> typed Vss.Vehicle... tree
    │   │   │   └── vss_profile_builder.dart        # *.profile.json -> const VehicleProfile
    │   │   └── vss_gen.dart                        # Builder factories
    │   ├── build.yaml                              # Custom builder declarations
    │   └── pubspec.yaml
    │
    ├── vehicle_domain/                             # [2. INTELLIGENCE / RULES LAYER]
    │   ├── lib/
    │   │   ├── src/
    │   │   │   ├── vss/                            # vehicle.vss.json (master spec) + generated code
    │   │   │   ├── profile/                        # VehicleProfile + ActiveVehicleProfile
    │   │   │   ├── broker/                         # VssBroker + vssValueProvider (granular)
    │   │   │   ├── dispatcher/                     # CommandDispatcher, CommandValidator, CommandSink
    │   │   │   ├── safety_rules/                   # 19 rules: DiffLock, BrakeToShift, OtaInstall...
    │   │   │   ├── behaviors/                      # VehicleBehaviors: auto-lock, auto-park, ESC...
    │   │   │   ├── power/                          # PowerMode, functional availability
    │   │   │   ├── e2e/                            # E2E protection, E2eReceiver, signal status
    │   │   │   ├── hmi/                            # HMI lockouts, cluster telltales, message center
    │   │   │   └── logger/                         # VehicleLogger (audit log)
    │   │   └── vehicle_domain.dart
    │   ├── build.yaml                              # Enables vss_gen:vss_tree
    │   └── pubspec.yaml
    │
    ├── zonal_system/                               # [3. HARDWARE & ZONAL LAYER]
    │   ├── lib/
    │   │   ├── src/
    │   │   │   ├── bus/                            # ZonalCommandBus & ZonalCommandSink
    │   │   │   ├── domain/                         # VehicleZone, ZonalRoute, ZonalCommand
    │   │   │   ├── controllers/                    # West, East and Central zone ECUs
    │   │   │   ├── modules/                        # BodySideEcu (doors, shades, seats per side)
    │   │   │   ├── hvac/                           # CabinThermalModel (cabin temp + AUTO fan)
    │   │   │   ├── power/                          # VehicleModeManager, ZoneNetworkManagement
    │   │   │   ├── actuators/                      # DumbDoorActuator, DumbSunroofActuator
    │   │   │   └── zonal_system_bootstrap.dart     # Boots one ECU per zone
    │   │   └── zonal_system.dart
    │   └── pubspec.yaml
    │
    ├── vehicle_profiles/                           # [4. MODEL CAPABILITY MATRIX]
    │   ├── lib/
    │   │   ├── src/profiles/
    │   │   │   ├── *.profile.json                  # entry, premium, luxury_ev_suv, flagship
    │   │   │   └── factory_profiles.dart           # factoryProfiles (generated and validated)
    │   │   └── vehicle_profiles.dart
    │   ├── build.yaml                              # Enables vss_gen:vss_profile
    │   └── pubspec.yaml
    │
    ├── vehicle_simulators/                         # [5. SIMULATED SENSORS (dev & test)]
    │   ├── lib/
    │   │   ├── src/
    │   │   │   ├── telemetry_simulator.dart        # Sensors, commands, MANUAL and FORCED
    │   │   │   ├── e2e_transmitter.dart            # Protected sensor frames + fault injection
    │   │   │   ├── driving_simulator.dart          # 30 Hz drive: ACC, lead car, lanes, power
    │   │   │   └── simulation_scenario.dart        # Scenarios: readings + commands
    │   │   └── vehicle_simulators.dart
    │   └── pubspec.yaml
    │
    └── vehicle_ui_kit/                             # [6. SHARED DESIGN SYSTEM]
        ├── lib/
        │   ├── src/
        │   │   ├── vehicle_feature_guard.dart      # Hides widgets the profile doesn't support
        │   │   ├── vehicle_command_switch.dart     # Switch bound to a boolean actuator
        │   │   ├── safety_precheck_banner.dart     # Warns ahead with the safety rule message
        │   │   ├── vehicle_control_card.dart       # Common card shell
        │   │   ├── vehicle_widget_ref.dart         # ref.watchSignal / ref.dispatchCommand
        │   │   └── car_profile_selector_bar.dart   # Live profile switch
        │   └── vehicle_ui_kit.dart
        └── pubspec.yaml
```

## Layered architecture

```
   ┌──────────────────────────────────────────────────────────────────────┐
   │  apps: infotainment · digital_cluster                                │
   │  (main.dart is the composition root and wires every package)         │
   └───────┬────────────────┬────────────────┬───────────────┬────────────┘
           │                │                │               │
    vehicle_ui_kit   vehicle_profiles   zonal_system   vehicle_simulators
           │                │                │               │
           └────────────────┴──▶ vehicle_domain ◀────────────┘
                                       ▲
                                       └──── vss_gen (dev_dependency, codegen)
```

- **`vehicle_domain` depends on no other project package.** It defines `CommandSink`;
  `zonal_system` implements it and the app wires both in the `ProviderScope`.
- Domain packages are **pure Dart** (no Flutter); widgets live in apps and `vehicle_ui_kit`.

## Command flow

```
UI ──▶ CommandDispatcher ──▶ CommandValidator (profile → actuator → range → power mode → SafetyRules)
                                   │
                         approved  ▼
                     ZonalCommandSink ──▶ ZonalRoute ──▶ ZonalCommandBus
                                                            │
                                     zone ECU ──▶ actuator ─┘
                                         │
UI ◀── vssValueProvider ◀── VssBroker ◀──┘  (confirmed telemetry)
                             ▲    │
   E2eReceiver (CRC, counter,     └──▶ VehicleBehaviorEngine ──▶ CommandDispatcher (auto-lock, ...)
   deadline) ◀── TelemetrySimulator (protected sensor frames, cyclic)
```

The UI never reads back the command it sent: it only shows what the ECU confirmed in the broker.
Three kinds of logic live in the domain:

| Concept | Question it answers | Examples |
|---|---|---|
| `SafetyRule` | "Can this command run now?" | Brake to shift, diff lock below 30 km/h, OTA only when empty |
| `VehicleBehavior` | "What should the car do on its own?" (issues commands via the dispatcher) | Auto-lock, auto-park, diff lock → ESC off, crash response |
| HMI lockout | "Can the driver use this screen feature now?" | Video and keyboard above 8 km/h |

## Multiple models without compile errors

- One **master VSS spec** (`vehicle_domain/lib/src/vss/vehicle.vss.json`) holds the union of
  every signal, so all code compiles for every model.
- Each model is a **profile** (`vehicle_profiles/lib/src/profiles/*.profile.json`): the signals
  it has, `min`/`max`/`allowed` adjustments and the driver side (LHD/RHD).
- An unknown path in a profile **fails the build**.
- At runtime the active profile hides widgets (`VehicleFeatureGuard`), rejects commands
  (`notSupportedByVehicle`) and filters telemetry in the broker.
- A new model app (e.g. `sedan_infotainment`) is just another `main.dart` with another profile.

## Getting started

```bash
flutter pub get                      # resolves the whole workspace (at the root)
dart pub global activate melos       # optional: to call `melos` directly

melos run generate                   # build_runner (Riverpod + VSS) in topological order
melos run analyze
melos run test:dart                  # pure Dart packages
melos run test:flutter               # ui_kit + apps

cd apps/infotainment && flutter run  # then open the Simulator tab
```

Without the global install, use `dart run melos <command>`. Generated files (`*.g.dart`) are
committed; run `generate` after editing the spec, a profile or a `@riverpod` provider.

> Open the **repository root** in the IDE, not each package: dependencies live in the root
> `.dart_tool/package_config.json`.

## Packages

| Package | Layer | README |
|---|---|---|
| `vss_gen` | 1. VSS signals (codegen) | [packages/vss_gen](packages/vss_gen/README.md) |
| `vehicle_domain` | 2. Intelligence / rules | [packages/vehicle_domain](packages/vehicle_domain/README.md) |
| `zonal_system` | 3. Hardware & zonal | [packages/zonal_system](packages/zonal_system/README.md) |
| `vehicle_profiles` | 4. Capability matrix | [packages/vehicle_profiles](packages/vehicle_profiles/README.md) |
| `vehicle_simulators` | 5. Simulated sensors | [packages/vehicle_simulators](packages/vehicle_simulators/README.md) |
| `vehicle_ui_kit` | 6. Design system | [packages/vehicle_ui_kit](packages/vehicle_ui_kit/README.md) |
| `infotainment` | App | [apps/infotainment](apps/infotainment/README.md) |
| `digital_cluster` | App | [apps/digital_cluster](apps/digital_cluster/README.md) |

## Feature guides

| Guide | What |
|---|---|
| [Power modes](docs/power-modes.md) | OFF/ACC/ON/READY/CHARGING, HV pre-charge, sleep and wake-up, 12 V battery, functional availability |
| [E2E signal protection](docs/e2e-signal-protection.md) | Alive counter + CRC, signal status, fail-safe rules, fault injection |
| [Digital cluster](docs/digital-cluster.md) | Tesla/Rivian-style cluster, telltales, message center, 60 FPS rendering |
| [IPC bridge](docs/ipc-bridge.md) | Design for sharing one vehicle core between the HMIs |

Each guide ends with **Gaps vs. a production ECU**.

## Roadmap

1. IPC bridge so the cluster reads the infotainment's car ([docs/ipc-bridge.md](docs/ipc-bridge.md)).
2. Diagnostics: DTCs with freeze frames, UDS-style read/clear, limp modes tied to E2E faults.
3. Deterministic scheduler (1/10/100 ms tasks, virtual clock), record & replay of drives.
4. Actuator protection: commanded vs. actual, stall detection, anti-pinch.
5. Overlay file for custom signals; reset actuators on profile switch; Row2 middle seat.
6. CI (analyze, tests, generated-code check) and `riverpod_lint`.
