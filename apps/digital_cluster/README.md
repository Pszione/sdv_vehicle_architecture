# digital_cluster

App Flutter do **painel de instrumentos** (velocímetro, ADAS, alertas), com meta de 60 FPS.

> **Status:** ainda é o template do Flutter. Não está ligado ao `VssBroker`.

## Direção planejada

- Depender de `vehicle_domain` + `vehicle_ui_kit`.
- Cada gauge observa um único sinal com `ref.watchSignal` e desenha com `CustomPainter`
  dentro de um `RepaintBoundary`.
- Interpolar com `Ticker` entre as amostras de telemetria (ADAS a 30 Hz) para animar a 60 FPS.
- Compartilhar estado com o infotainment exige um core comum (ver *Roadmap* no README da raiz).

## Rodar

```
flutter run
```
