# vehicle_domain

**Camada 2: Inteligência e regras.** Dart puro. Contém o contrato de sinais (spec VSS mestre),
o estado confirmado do carro, o pipeline de comandos e as regras de segurança.
**Não conhece a topologia E/E**: comandos aprovados saem por uma interface (`CommandSink`).

## Componentes

| Componente | Papel |
|---|---|
| `Vss` / `vssCatalog` | API tipada gerada de `lib/src/vss/vehicle.vss.json` |
| `VehicleProfile` + `activeVehicleProfileProvider` | Quais sinais existem no modelo ativo (LHD/RHD, overrides) |
| `VssBroker` | Último valor confirmado de cada sinal. Só ECUs e simuladores publicam |
| `vssValueProvider(signal)` | Leitura granular: só notifica quando aquele sinal muda |
| `CommandDispatcher` | Entrada única de comandos: valida, loga e envia ao `CommandSink` |
| `CommandValidator` | Pipeline puro: capacidade → atuador → faixa do spec → `SafetyRule`s |
| `canDispatchProvider(command)` | Dry run reativo, para habilitar/desabilitar controles |
| `SafetyRule`s | Porta, teto solar, câmbio, recarga EV, pré-condicionamento, diferencial, suspensão, capota |
| `VehicleLogger` | Audit log em ring buffer: comandos, rejeições e mudanças de atuadores |

## Fluxo de um comando

```
VehicleCommand(signal: Vss..., value: ...)
  └─▶ CommandDispatcher.dispatch
        ├─ sinal existe no perfil?          não → notSupportedByVehicle
        ├─ é atuador?                       não → readOnlySignal
        ├─ valor dentro de min/max/allowed? não → invalidPayload
        ├─ SafetyRules com target == sinal  falha → rejectedBySafetyRule (logado)
        └─ CommandSink.send(command)        → approved
```

A confirmação física chega depois, como telemetria publicada no `VssBroker`.

## Providers que o app precisa sobrescrever

```dart
ProviderContainer(overrides: [
  initialVehicleProfileProvider.overrideWithValue(luxuryEvSuvProfile),
  commandSinkProvider.overrideWith((ref) => ZonalCommandSink(ref.watch(zonalCommandBusProvider))),
]);
```

## Adicionar uma SafetyRule

1. Implemente `SafetyRule`: declare `target` (atuador), `inputs` (sinais lidos) e `validate`.
2. Retorne `null` se for seguro e `CommandResult.rejected('motivo')` se não for. Ações de liberação
   (destravar, fechar, desengatar) são sempre permitidas. Documente o que acontece quando um input está ausente.
3. Registre em `activeSafetyRulesProvider`. A regra só roda se o `target` existe no perfil ativo.

## Adicionar sinais

Edite `lib/src/vss/vehicle.vss.json` seguindo a nomenclatura do COVESA VSS mais recente
e rode `dart run build_runner build`. Nunca edite `*.g.dart`.

## Estrutura

```
lib/src/
├── vss/            # vehicle.vss.json (spec mestre), VssSignal, árvore gerada
├── profile/        # VehicleProfile, perfil ativo, isSignalSupported
├── broker/         # VssBroker, vssValueProvider, SignalReader
├── dispatcher/     # CommandDispatcher, CommandValidator, CommandSink, canDispatch
├── safety_rules/   # SafetyRule + implementações + activeSafetyRulesProvider
└── logger/         # VehicleLogger (audit log)
```

## Testes

```
dart test
```
