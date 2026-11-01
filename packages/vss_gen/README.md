# vss_gen

**Layer 1: VSS signals.** build_runner builders that turn the
[COVESA VSS](https://covesa.github.io/vehicle_signal_specification/) spec (vss-tools JSON
export shape) into typed Dart code. It is a `dev_dependency`: nothing from this package ships in the app.

## Builders

| Builder | Input | Output |
|---|---|---|
| `vss_gen:vss_tree` | `*.vss.json` | `*.vss.g.dart`: `Vss.Vehicle...` tree + `vssCatalog` |
| `vss_gen:vss_profile` | `*.profile.json` | `*.profile.g.dart`: `const VehicleProfile` |

- Every leaf becomes a `const VssSignal<T>` typed from its VSS `datatype`
  (`boolean`→`bool`, `uint8`/`int16`…→`int`, `float`/`double`→`double`, `string`→`String`, `T[]`→`List<T>`).
- Class names use the full path (`_VssVehicleCabinDoorRow1`), so branches with the same
  name under different parents never collide.
- `vssCatalog` holds `type` (sensor/actuator/attribute), `unit`, `min`, `max`, `allowed` and `default`.
- Profiles are validated against the master spec: an unknown path, an invalid override or a
  missing field **fails the build**.

## Usage

The builders are opt-in (`auto_apply: none`). Enable them in the consumer's `build.yaml`:

```yaml
# vehicle_domain/build.yaml
targets:
  $default:
    builders:
      vss_gen:vss_tree:
        enabled: true          # default part_of: vss.dart

# vehicle_profiles/build.yaml
targets:
  $default:
    builders:
      vss_gen:vss_profile:
        enabled: true
        options:
          spec: package:vehicle_domain/src/vss/vehicle.vss.json
```

The library named by `part_of` must import `VssSignal`, `VssSignalMeta` and `VssNodeType`
(tree) or `VehicleProfile`, `DriverSide` and `VssMetaOverride` (profiles).

## Structure

```
lib/
├── vss_gen.dart                   # Builder factories (referenced by build.yaml)
└── src/
    ├── vss_spec.dart              # VSS spec parser + validation
    ├── vss_tree_builder.dart      # *.vss.json -> typed tree + catalog
    └── vss_profile_builder.dart   # *.profile.json -> const VehicleProfile
build.yaml                         # Builder declarations
```

## Tests

```
dart test
```
