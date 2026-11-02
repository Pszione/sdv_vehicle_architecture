# digital_cluster

Flutter app for the **instrument cluster**, in the style of current Tesla / Rivian clusters,
built for an iPad in landscape: big speed, PRND, power/regen meter, live ADAS road view
(lanes, lead vehicle, ACC gap), battery and range, only the active telltales, and a driver
message center. **Read-only**: it never sends a vehicle command.

Design, benefits and gaps: [docs/digital-cluster.md](../../docs/digital-cluster.md).

## Run

```
flutter run
```

The app runs in **standalone mode**: it hosts its own vehicle core (broker, zonal ECUs, simulators)
and shows a *DEMO* bar of simulated driver inputs: Brake + START, drives (City, Highway, Lane drift,
Lead car brakes), Park, ACC, lane keeping, turn signals, hazards, high beam, door, seatbelt, tire,
frozen speed. With the IPC bridge ([docs/ipc-bridge.md](../../docs/ipc-bridge.md)) it would read the
infotainment's car instead, and the demo bar would go away.

## Structure

```
lib/
├── main.dart                         # Composition root (standalone vehicle core)
├── app/cluster_app.dart              # MaterialApp, near-black theme
├── core/
│   ├── cluster_colors.dart           # Palette, ISO 2575 telltale colors
│   └── interpolated_value.dart       # 30 Hz samples -> 60 FPS values
├── dev/demo_drive_bar.dart           # Standalone demo inputs (remove with the IPC bridge)
└── features/cluster/view/
    ├── cluster_screen.dart           # Off / charging / driving layouts
    └── widgets/                      # telltale_bar, speed_readout, gear_indicator, power_meter,
                                      # adas_view, battery_status, message_center_panel, trip_info
```

## Rendering rules (60 FPS)

- Each widget watches only the signals it shows (`ref.watchSignal`, `telltaleStateProvider(t)`).
- High-rate visuals (`AdasView`, `PowerMeter`) **listen** to signals and repaint a `CustomPainter`
  from a notifier inside a `RepaintBoundary`: no widget rebuild per frame.
- The road view's ticker runs only while something moves.
- Invalid or lost signals are shown as such (`--`, *Camera unavailable*), never as stale values.
