# vehicle_ui_kit

**Design system compartilhado** pelas HMIs (infotainment e cluster). Depende só do `vehicle_domain`.

## Componentes

| Componente | Papel |
|---|---|
| `ref.watchSignal(Vss...)` | Observa **um** sinal tipado; o widget só reconstrói quando ele muda |
| `ref.dispatchCommand(context, command)` | Envia pelo `CommandDispatcher` e mostra o motivo se for recusado |
| `VehicleFeatureGuard` | Mostra o widget só se o sinal existe no perfil ativo (ou um `fallback`) |
| `CarProfileSelectorBar` | Troca o perfil ao vivo (ferramenta de simulação) |

## Exemplo

```dart
class SunroofStatus extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watchSignal(Vss.Vehicle.Cabin.Sunroof.Position) ?? 0.0;
    return Text('${(position * 100).round()}% aberto');
  }
}

VehicleFeatureGuard(
  signal: Vss.Vehicle.Cabin.Sunroof.Position,
  child: const SunroofControlCard(),
);
```

## Regras para widgets

- Nunca observe o mapa inteiro do `VssBroker`: use `watchSignal`, ou `.select` para campos do perfil.
- A UI nunca escreve no broker; ela só envia `VehicleCommand`s e exibe a telemetria confirmada.
