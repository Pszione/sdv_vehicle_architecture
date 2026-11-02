# Digital instrument cluster

A driver display in the style of current **Tesla / Rivian** clusters, built for an iPad in
landscape: near-black, one large speed, a live ADAS road view in the center, and only the
telltales that are on. It is **read-only**: it never sends a vehicle command.

```
┌───────────────────────────────────────────────────────────────────────────┐
│ ◀            [only active telltales: P  ESC  seatbelt  door  TPMS ...]  ▶ │
├──────────────────┬───────────────────────────────────┬────────────────────┤
│ P                │                                   │          78 %  🔋  │
│ R     124        │     ADAS road view                │          351 km    │
│ N     km/h       │     lanes curving ahead,          │  ┃ warning card    │
│ D                │     lead car at its distance,     │  ┃ fault card      │
│ (120) ACC 120 ▮▮ │     ACC gap bars, ego car         │  ┃ info card       │
│ ▬▬▬▬|▬▬▬▬▬ kW    │                                   │  READY · ODO       │
└──────────────────┴───────────────────────────────────┴────────────────────┘
  DEMO (standalone): START · City · Highway · Lane drift · Lead car brakes · ACC · ...
```

## Why it is built this way (benefits)

| Choice | Benefit |
|---|---|
| **Telltale and message logic in the domain** (`TelltaleLogic`, `DriverMessageCenter`) | Testable without Flutter, identical on any display (cluster, HUD, phone app), and reviewable by safety people without reading widget code |
| **One provider per telltale** watching only its inputs | At 60 FPS a speed change never re-evaluates the parking brake light |
| **Bulb check** for 2 s when entering READY | Every lamp proves it works, a regulatory expectation for red telltales |
| **Telltales lit only in ON/READY** | Like a real cluster: off car, dark cluster |
| **Signal status shown honestly** | A frozen or lost speed shows `--`; lost camera/radar hide the lanes or the lead car and show *Camera unavailable* instead of drawing stale data |
| **Painters, not rebuilds** | The road view, the power meter and the gauges repaint from notifiers driven by a ticker; widgets rebuild only when a *displayed* value changes |
| **30 Hz → 60 FPS interpolation** (`InterpolatedValue`) | Camera/radar data arrives at 30 Hz; the painter moves smoothly between samples instead of stepping |
| **Ticker that sleeps** | The road view's ticker stops when nothing moves (car stopped, interpolation done): no GPU work for a static screen |
| **Message priority queue** | Warnings before faults before information, de-duplicated; information fades out, faults stay until the signal recovers |

## Architecture

| Layer | Piece | Role |
|---|---|---|
| Domain | `Telltale`, `TelltaleLogic` | 14 telltales with ISO 2575 colors and their activation logic (e.g. seatbelt reminder flashes above 25 km/h, door open flashes when moving) |
| Domain | `telltaleStateProvider(t)`, `BulbCheck` | Granular state per telltale, gated by power mode |
| Domain | `DriverMessageQueue`, `DriverMessageCenter` | Messages from the audit log (rejections, behaviors, signal faults) and power mode changes |
| Simulators | `DrivingSimulator` (30 Hz) | Ego speed with ACC gap control, lead vehicle, lane geometry, FCW and lane-departure warnings, traction power, odometer, SoC and range |
| App | `ClusterScreen` | Off / charging / driving layouts |
| App | `AdasView` | Perspective road (curvature, lateral offset, dashes scrolling at the real speed), lead car, gap bars; one `CustomPainter` |
| App | `dev/DemoDriveBar` | **Standalone only**: simulated driver inputs. Remove once the cluster uses the IPC bridge |

### Signals used (COVESA unless marked)

Speed, `Powertrain.Transmission.SelectedGear`, `TractionBattery.CurrentPower / StateOfCharge`,
`Powertrain.Range`, `TraveledDistance`, `Body.Lights.DirectionIndicator.*/Hazard/Beam.High`,
`Chassis.ParkingBrake.IsEngaged`, tire `IsPressureLow`, `ADAS.ESC.IsEngaged/Mode`,
`ADAS.CruiseControl.IsActive/SpeedSet/AdaptiveIntervalSet`, `ADAS.ObstacleDetection.Front.Center.*`,
`ADAS.LaneDepartureDetection.IsWarning`, `LowVoltageBattery.CurrentVoltage`; custom:
`ADAS.LaneKeepingAssist.LateralOffset/Curvature`, `ADAS.TrafficSignRecognition.SpeedLimit`.

## Run it

```
cd apps/digital_cluster && flutter run      # iPad (landscape) or any simulator
```

Standalone demo: **Brake + START** (bulb check, then READY) → **Highway** → **ACC** and
**Lane keep** → **Lead car brakes** (forward-collision warning, ACC slows down) → **Lane drift**
with lane keeping off (red lane line, amber telltale) → **Frozen speed** (`--`, fault card) →
**Park** → **Power off**.

## Gaps vs. a production cluster

- **Safety partition** (intentionally out of scope for now): production telltales run on a separate
  ASIL-B partition or safety island, with image-checksum monitoring of the rendered telltale area
  and a fallback renderer.
- **Telltale symbols** are Material icons/text, not the ISO 2575 artwork; no luminance/day-night
  control, no telltale priority arbitration when space is short.
- **Timing**: no frame-budget monitoring, no frozen-frame detection, no defined maximum latency
  from signal to pixel.
- **Message center**: no persistent warnings tied to DTCs, no driver acknowledgement logging,
  no chimes (acoustic warnings are part of most red telltales).
- **ADAS view**: a stylized 2-lane model; real systems render the perception object list
  (vehicles, pedestrians, cones), lane types and the planned path.
- **Units and locale**: km/h and °C only; no mph, no regional telltale variants.
- **Process separation**: in standalone mode the cluster runs its own vehicle core; see
  [ipc-bridge.md](ipc-bridge.md) for sharing the infotainment's.
