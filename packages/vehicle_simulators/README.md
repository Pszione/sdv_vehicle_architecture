# vehicle_simulators

**Simulated world around the car (dev & test tooling).** Pure Dart. Drives the vehicle
without hardware, through four clearly separated paths:

| Method | For | Path |
|---|---|---|
| `report(signal, value)` | **Sensors** (speed, seat occupancy, SoC, seatbelt...) | Published to the `VssBroker`, as an ECU would. Actuators are refused (`ArgumentError`) |
| `command(signal, value)` | **Actuators** (locks, gear, diff lock...) | Through the `CommandDispatcher` with source `SIMULATOR`: every safety rule applies |
| `operateManually(signal, value)` | **By hand** (door handle, manual tailgate) | Published as the zone ECU reports the latch, no command so no rule, logged as `MANUAL` |
| `forceActuatorState(signal, value)` | Fault testing | Written straight to the broker, **bypassing every rule**, and logged as `FORCED` |

The broker still validates every value against the spec and the active profile: a signal
the car does not have returns `notSupported`, an out-of-range value `outOfRange`.

`forceActuatorState` does not tell the zonal ECU, so its internal actuator state may differ
until the next real command.

## Scenarios

A `SimulationScenario` is a sequence of steps: `SimulatedReading` (sensor), `SimulatedManualOperation` (by hand) and
`SimulatedCommand` (actuator, through the dispatcher).

| Scenario | What it does |
|---|---|
| Parked & aligned | PARK, 0 km/h, doors closed, unplugged, 80% SoC, 20 °C, no crash |
| City driving | Unplugged, brake pressed → DRIVE, 45 km/h (auto-lock locks the doors) |
| Highway | Same at 130 km/h (auto-lock, suspension lowers itself) |
| Tight trail turn | 10 km/h, wheel turned 35° |
| Plugged in, low battery | PARK, charging, 10% SoC |
| Driver door open | Stopped, driver door open |
| Driver leaves in DRIVE | Stopped in DRIVE, seatbelt off, door open (auto-park) |
| Ready for OTA | PARK, nobody inside, doors closed and locked, 80% SoC |
| Family on board | Every seat occupied |
| Start (READY) | Driver on board, brake + START, HV pre-charge (`SimulationScenario.startReady`) |
| Walk away | Park, power off, get out, key away: walk-away lock, sleep after 10 s |
| Weak 12 V battery | 12 V at 11.5 V: Sentry/Camp/Dog refuse to start |
| Winter morning | -5 °C outside, 2 °C cabin |
| Summer heat | 35 °C outside, 48 °C cabin (try AUTO on the Climate tab) |
| Crash | Crash detected (doors unlock, hazards on) |

## Usage

```dart
final simulator = ref.read(telemetrySimulatorProvider.notifier);
simulator.report(Vss.Vehicle.Speed, 45.0);                                   // sensor
simulator.command(Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked, true); // rejected at 45 km/h
simulator.forceActuatorState(Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked, true); // FORCED
simulator.apply(SimulationScenario.presets.first);                           // parked & aligned
```

## E2E-protected sensors

Speed, brake pedal, steering angle, charging cable, crash and the ADAS camera/radar signals go
through an `E2eTransmitter` (alive counter + CRC) to the gateway's `E2eReceiver`, on change and
cyclically once `startCyclicTransmission()` is called at boot. Faults can be injected per signal:

```dart
simulator.injectE2eFault(Vss.Vehicle.Speed, E2eFault.frozenSender); // REPEATED -> INVALID
```

`frozenSender`, `bitFlip`, `frameLoss`, `senderDead` (STALE) and `masquerade`. Sleeping sensor ECUs
(power mode SLEEP) stop transmitting. See [docs/e2e-signal-protection.md](../../docs/e2e-signal-protection.md).

## Driving simulator (30 Hz)

`drivingSimulatorProvider.notifier.start(DriveProfile.highway)` plays a drive while the car is READY
in DRIVE: ego speed with adaptive cruise gap control, a lead vehicle (optionally braking hard),
lane drift and curvature, forward-collision and lane-departure warnings, traction power (regen
included), odometer, SoC and range. Presets: City, Highway, Lane drift, Lead car brakes.

## Planned

- Gaussian sensor noise and plausibility faults (a *valid* frame with a wrong value).
- Recording and replay of drives.
