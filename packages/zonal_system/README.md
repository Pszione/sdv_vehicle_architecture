# zonal_system

**Layer 3: Hardware & zonal architecture.** Pure Dart. Simulates the central gateway,
the bus between zones, the zonal ECUs and "dumb" actuators with latency and faults.
Implements the `CommandSink` from `vehicle_domain`.

## Components

| Component | Role |
|---|---|
| `ZonalCommandSink` | Receives approved commands and resolves their route (`ZonalRoute`) |
| `ZonalRoute` | Typed table signal → (zone, device). No entry → central ECU |
| `ZonalCommandBus` | Broadcast event stream (not Riverpod state, so no command is ever coalesced) |
| `TopZoneController` | Sunroof, moving at 10 Hz with fault injection |
| `DoorZoneController(zone)` | Door locks in the west/east zones |
| `GenericZoneController(zone)` | South/central: confirms the commanded value (HVAC, seats, suspension…) |
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
  commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
]);
container.read(zonalSystemProvider); // boot the ECUs before the first command
```

## Fault injection

```dart
container.read(topZoneControllerProvider.notifier).injectSunroofFault(ActuatorFaultType.mechanicalJam);
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
