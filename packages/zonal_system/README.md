# zonal_system

**Camada 3: Hardware e arquitetura zonal.** Dart puro. Simula o gateway central,
o barramento entre zonas, as ECUs zonais e os atuadores "burros" com latência e falhas.
Implementa o `CommandSink` do `vehicle_domain`.

## Componentes

| Componente | Papel |
|---|---|
| `ZonalCommandSink` | Recebe comandos aprovados e resolve a rota (`ZonalRoute`) |
| `ZonalRoute` | Tabela tipada sinal → (zona, dispositivo). Sem entrada → ECU central |
| `ZonalCommandBus` | Stream de eventos broadcast (não é estado do Riverpod: nenhum comando é perdido) |
| `TopZoneController` | Teto solar com movimento a 10 Hz e injeção de falha |
| `DoorZoneController(zone)` | Travas das portas das zonas west/east |
| `GenericZoneController(zone)` | South/central: confirma o valor comandado (HVAC, bancos, suspensão…) |
| `DumbSunroofActuator`, `DumbDoorActuator` | Atuadores físicos simulados |
| `zonalSystemProvider` | Liga uma ECU por zona. Leia no boot do app |

## Fluxo

```
CommandSink.send ─▶ ZonalRoute.of(signal) ─▶ ZonalCommandBus.emit
   └─▶ ECU da zona ─▶ atuador ─▶ VssBroker.publish(valor confirmado)
```

## Uso no app

```dart
final container = ProviderContainer(overrides: [
  commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
]);
container.read(zonalSystemProvider); // boot das ECUs antes do primeiro comando
```

## Fault injection

```dart
container.read(topZoneControllerProvider.notifier).injectSunroofFault(ActuatorFaultType.mechanicalJam);
```

O atuador trava em 50% do curso e a ECU publica `Vehicle.Cabin.Sunroof.IsFaulted = true`.

## Adicionar um atuador com modelo físico

1. Crie o atuador em `src/actuators/`.
2. Crie (ou estenda) a ECU da zona em `src/controllers/`, como `@Riverpod(keepAlive: true)`.
3. Adicione a rota em `ZonalRoute` e registre a ECU em `zonalSystemProvider`.

## Testes

```
dart test
```
