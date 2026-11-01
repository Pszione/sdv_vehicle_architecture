# SDV Vehicle Architecture

Ecossistema de software para um **veículo elétrico de luxo definido por software (SDV)**,
em Flutter/Dart. O "cérebro" do carro (sinais VSS, regras de segurança, ECUs zonais e
atuadores) é Dart puro; as HMIs são apps Flutter que só enviam comandos e exibem telemetria.

Inspirado em arquiteturas como Rivian, Tesla e Porsche e nos conceitos da COVESA / Eclipse SDV.

**Stack:** Dart 3.10 · Flutter 3.38 · Riverpod 3 (codegen) · Melos 8 (pub workspace) ·
`build_runner` · COVESA VSS (Vehicle Signal Specification)

## Estrutura do monorepo

```text
sdv_vehicle_architecture/
│
├── pubspec.yaml                                    # Pub workspace + scripts do Melos
├── analysis_options.yaml                           # Lints compartilhados (pacotes Dart puros)
├── CLAUDE.md                                       # Guia de arquitetura para agentes de IA
│
├── apps/                                           # APLICAÇÕES FINAIS (Executáveis)
│   ├── infotainment/                               # App Flutter da Central Multimídia do EV SUV
│   │   ├── lib/
│   │   │   ├── main.dart                           # Composition root: perfil + barramento zonal
│   │   │   ├── app/                                # MaterialApp + seletor de perfil
│   │   │   └── features/settings/                  # Telas do veículo (Travas, Teto, Massagem)
│   │   └── pubspec.yaml                            # Aponta para os 4 pacotes de domínio/UI
│   │
│   └── digital_cluster/                            # App Flutter do Painel de Instrumentos (template)
│       ├── lib/
│       │   └── main.dart
│       └── pubspec.yaml
│
└── packages/                                       # MÓDULOS DE DOMÍNIO REUTILIZÁVEIS
    │
    ├── vss_gen/                                    # [1. CAMADA DE SINAIS VSS]
    │   ├── lib/
    │   │   ├── src/
    │   │   │   ├── vss_spec.dart                   # Parser + validação do spec VSS (JSON vss-tools)
    │   │   │   ├── vss_tree_builder.dart           # *.vss.json -> árvore Vss.Vehicle... tipada
    │   │   │   └── vss_profile_builder.dart        # *.profile.json -> const VehicleProfile
    │   │   └── vss_gen.dart                        # Factories dos builders
    │   ├── build.yaml                              # Declaração dos custom builders
    │   └── pubspec.yaml
    │
    ├── vehicle_domain/                             # [2. CAMADA DE INTELIGÊNCIA / REGRAS]
    │   ├── lib/
    │   │   ├── src/
    │   │   │   ├── vss/                            # vehicle.vss.json (spec master) + código gerado
    │   │   │   ├── profile/                        # VehicleProfile + ActiveVehicleProfile
    │   │   │   ├── broker/                         # VssBroker + vssValueProvider (granular)
    │   │   │   ├── dispatcher/                     # CommandDispatcher, CommandValidator, CommandSink
    │   │   │   ├── safety_rules/                   # DoorSafetyRule, SunroofSpeedSafetyRule...
    │   │   │   └── logger/                         # VehicleLogger (audit log)
    │   │   └── vehicle_domain.dart
    │   ├── build.yaml                              # Habilita vss_gen:vss_tree
    │   └── pubspec.yaml
    │
    ├── zonal_system/                               # [3. CAMADA DE HARDWARE & ZONAL]
    │   ├── lib/
    │   │   ├── src/
    │   │   │   ├── bus/                            # ZonalCommandBus & ZonalCommandSink
    │   │   │   ├── domain/                         # VehicleZone, ZonalRoute, ZonalCommand
    │   │   │   ├── controllers/                    # TopZone, DoorZone(west/east), GenericZone...
    │   │   │   ├── actuators/                      # DumbDoorActuator, DumbSunroofActuator
    │   │   │   └── zonal_system_bootstrap.dart     # Boot de uma ECU por zona
    │   │   └── zonal_system.dart
    │   └── pubspec.yaml
    │
    ├── vehicle_profiles/                           # [4. MATRIZ DE CAPACIDADES DOS MODELOS]
    │   ├── lib/
    │   │   ├── src/profiles/
    │   │   │   ├── *.profile.json                  # entry, premium, luxury_ev_suv, flagship
    │   │   │   └── factory_profiles.dart           # factoryProfiles (gerados e validados)
    │   │   └── vehicle_profiles.dart
    │   ├── build.yaml                              # Habilita vss_gen:vss_profile
    │   └── pubspec.yaml
    │
    └── vehicle_ui_kit/                             # [5. DESIGN SYSTEM COMPARTILHADO]
        ├── lib/
        │   ├── src/
        │   │   ├── vehicle_feature_guard.dart      # Esconde widgets sem suporte no perfil
        │   │   ├── vehicle_widget_ref.dart         # ref.watchSignal / ref.dispatchCommand
        │   │   └── car_profile_selector_bar.dart   # Troca de perfil ao vivo
        │   └── vehicle_ui_kit.dart
        └── pubspec.yaml
```

## Arquitetura em camadas

```
   ┌──────────────────────────────────────────────────────────────┐
   │  apps: infotainment · digital_cluster                        │
   │  (main.dart é o composition root e liga todos os pacotes)    │
   └──────────┬──────────────────┬──────────────────┬─────────────┘
              │                  │                  │
       vehicle_ui_kit     vehicle_profiles     zonal_system
              │                  │                  │
              └────────────▶ vehicle_domain ◀───────┘
                                 ▲
                                 └──── vss_gen (dev_dependency, codegen)
```

- **`vehicle_domain` não depende de nada do projeto.** Ele define `CommandSink`, e o
  `zonal_system` implementa; o app liga os dois no `ProviderScope`.
- Pacotes de domínio são **Dart puro** (sem Flutter); widgets ficam em apps e no `vehicle_ui_kit`.

## Fluxo de um comando

```
UI ──▶ CommandDispatcher ──▶ CommandValidator (perfil → atuador → faixa → SafetyRules)
                                   │
                         aprovado  ▼
                     ZonalCommandSink ──▶ ZonalRoute ──▶ ZonalCommandBus
                                                            │
                                     ECU zonal ──▶ atuador ─┘
                                         │
UI ◀── vssValueProvider ◀── VssBroker ◀──┘  (telemetria confirmada)
```

A UI nunca lê o comando que enviou: ela mostra apenas o que a ECU confirmou no broker.

## Múltiplos modelos sem erro de compilação

- Um **spec VSS mestre** (`vehicle_domain/lib/src/vss/vehicle.vss.json`) contém a união de
  todos os sinais. Todo o código compila para qualquer modelo.
- Cada modelo é um **perfil** (`vehicle_profiles/lib/src/profiles/*.profile.json`): lista os
  sinais que existem, ajustes de `min`/`max`/`allowed` e o lado do motorista (LHD/RHD).
- Um caminho inexistente em um perfil **quebra o build**.
- Em runtime o perfil ativo esconde widgets (`VehicleFeatureGuard`), recusa comandos
  (`notSupportedByVehicle`) e filtra telemetria no broker.
- Um novo app de modelo (ex: `sedan_infotainment`) é só outro `main.dart` com outro perfil.

## Primeiros passos

```bash
flutter pub get                      # resolve todo o workspace (na raiz)
dart pub global activate melos       # opcional: para usar `melos` direto

melos run generate                   # build_runner (Riverpod + VSS) em ordem topológica
melos run analyze
melos run test:dart                  # pacotes Dart puros
melos run test:flutter               # ui_kit + apps

cd apps/infotainment && flutter run
```

Sem a instalação global, use `dart run melos <comando>`. Os arquivos gerados (`*.g.dart`)
são commitados; rode `generate` depois de editar o spec, um perfil ou um provider `@riverpod`.

> Abra a **raiz** do repositório na IDE, não cada pacote: as dependências ficam no
> `.dart_tool/package_config.json` da raiz.

## Pacotes

| Pacote | Camada | README |
|---|---|---|
| `vss_gen` | 1. Sinais VSS (codegen) | [packages/vss_gen](packages/vss_gen/README.md) |
| `vehicle_domain` | 2. Inteligência / regras | [packages/vehicle_domain](packages/vehicle_domain/README.md) |
| `zonal_system` | 3. Hardware & zonal | [packages/zonal_system](packages/zonal_system/README.md) |
| `vehicle_profiles` | 4. Matriz de capacidades | [packages/vehicle_profiles](packages/vehicle_profiles/README.md) |
| `vehicle_ui_kit` | 5. Design system | [packages/vehicle_ui_kit](packages/vehicle_ui_kit/README.md) |
| `infotainment` | App | [apps/infotainment](apps/infotainment/README.md) |
| `digital_cluster` | App | [apps/digital_cluster](apps/digital_cluster/README.md) |

## Roadmap

1. Fechar a base: política fail-safe para sinais ausentes, reset de atuadores na troca de perfil.
2. Alinhar caminhos com o COVESA VSS 5 (`DriverSide`/`PassengerSide`) + overlay para sinais próprios.
3. Simuladores (ADAS a 30 Hz, fluxo de potência EV) e `digital_cluster` a 60 FPS.
4. Features: HVAC quadrizona, Sentry/Camp/Dog/Valet Mode, modos de condução.
5. CI (analyze, testes, verificação de código gerado) e `riverpod_lint`.
