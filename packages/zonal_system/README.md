# zonal_system

**Layer 3: Hardware & zonal architecture.** Pure Dart. Simulates the central gateway,
the bus between zones, the zonal ECUs and "dumb" actuators with latency and faults.
Implements the `CommandSink` from `vehicle_domain`.

## Components

| Component | Role |
|---|---|
| `ZonalCommandSink` | Receives approved commands and resolves their route (`ZonalRoute`) |
| `ZonalRoute` | Signal → (zone, device). Body signals map `DriverSide`/`PassengerSide` to the physical west/east zone using the profile's `driverSide`; HVAC and sunroof → central; anything else → central gateway |
| `ZonalCommandBus` | Broadcast event stream (not Riverpod state, so no command is ever coalesced) |
| `WestZoneController` / `EastZoneController` | One per physical side, both via `BodySideEcu`: door locks (`DumbDoorActuator`), shades, seat heat/massage |
| `CentralZoneController` | Sunroof (10 Hz, fault injection), HVAC with the 1 s `CabinThermalModel` (cabin temperature, AUTO fan) and the gateway echo for domain ECUs (powertrain, chassis, ADAS) |
| `CabinThermalModel` | Pure functions: cabin temperature step toward target/outside, AUTO fan percentage |
| `VehicleModeManager` | Central zone: 12 V state, HV contactors with pre-charge, retained accessory power, sleep, 12 V battery model (see [docs/power-modes.md](../../docs/power-modes.md)) |
| `ZoneNetworkManagement` | Per-zone bus state (awake / prepare sleep / asleep); a command to a sleeping zone wakes it and waits for the wake-up latency |
| `DumbSunroofActuator`, `DumbDoorActuator` | Simulated physical actuators |
| `zonalSystemProvider` | Starts one ECU per zone. Read it when the app boots |

## Flow

```
CommandSink.send ─▶ ZonalRoute.of(signal) ─▶ ZonalCommandBus.emit
   └─▶ zone ECU ─▶ actuator ─▶ VssBroker.publish(confirmed value)
```

## App wiring

```dart
final container = ProviderContainer(overrides: [
  commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
]);
// Listen, not read: Riverpod 3 does not re-evaluate providers nobody listens to.
container.listen(zonalSystemProvider, (_, _) {}); // boot the ECUs before the first command
```

## Fault injection

```dart
container.read(centralZoneControllerProvider.notifier).injectSunroofFault(ActuatorFaultType.mechanicalJam);
```

The actuator stops at 50% travel and the ECU publishes `Vehicle.Cabin.Sunroof.IsFaulted = true`.

## Adding an actuator with a physical model

1. Create the actuator in `src/actuators/`.
2. Create (or extend) the zone ECU in `src/controllers/` as `@Riverpod(keepAlive: true)`.
3. Add the route to `ZonalRoute` and register the ECU in `zonalSystemProvider`.

## Tests

```
dart test
```
