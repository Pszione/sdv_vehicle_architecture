# digital_cluster

Flutter app for the **instrument cluster** (speedometer, ADAS, alerts), targeting 60 FPS.

> **Status:** still the Flutter template. Not connected to the `VssBroker` yet.

## Planned direction

- Depend on `vehicle_domain` + `vehicle_ui_kit`.
- Each gauge watches a single signal with `ref.watchSignal` and paints with a `CustomPainter`
  inside a `RepaintBoundary`.
- Interpolate with a `Ticker` between telemetry samples (ADAS at 30 Hz) to animate at 60 FPS.
- Sharing state with the infotainment requires a common core (see *Roadmap* in the root README).

## Run

```
flutter run
```
