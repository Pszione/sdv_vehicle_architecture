# vehicle_simulators

**Simulated sensors (dev & test tooling).** Pure Dart. Publishes fake telemetry to the
`VssBroker` as if it came from ECUs, so the HMIs and safety rules can be exercised without hardware.

The broker still validates every reading against the spec and the active profile:
a sensor the car does not have is ignored (`SignalWriteResult.notSupported`), and an
out-of-range value is dropped (`outOfRange`).

## Components

| Component | Role |
|---|---|
| `TelemetrySimulator` | `report(signal, value)` for one reading, `apply(scenario)` for a set |
| `SimulationScenario` | Named set of `SimulatedReading`s that puts the car in a known situation |
| `SimulationScenario.presets` | Parked & aligned, City driving, Highway, Tight trail turn, Plugged in & low battery, Driver door open, Winter morning |

## Usage

```dart
final simulator = ref.read(telemetrySimulatorProvider.notifier);
simulator.report(Vss.Vehicle.Speed, 45.0);               // diff lock now blocked
simulator.apply(SimulationScenario.presets.first);       // parked & aligned
```

Only simulators and zonal ECUs publish telemetry. The UI never writes to the broker directly.

## Planned

- `AdasSimulatorEngine` at 30 Hz (speed, lead vehicle, lane offsets) for the digital cluster.
- EV power-flow simulator (power, SoC drain, regeneration).
