# vss_gen

**Camada 1: Sinais VSS.** Builders do `build_runner` que transformam o spec
[COVESA VSS](https://covesa.github.io/vehicle_signal_specification/) (formato JSON do
vss-tools) em código Dart tipado. É uma `dev_dependency`: nada deste pacote vai para o app.

## Builders

| Builder | Entrada | Saída |
|---|---|---|
| `vss_gen:vss_tree` | `*.vss.json` | `*.vss.g.dart`: árvore `Vss.Vehicle...` + `vssCatalog` |
| `vss_gen:vss_profile` | `*.profile.json` | `*.profile.g.dart`: `const VehicleProfile` |

- Cada folha vira um `const VssSignal<T>` com o tipo Dart do `datatype` VSS
  (`boolean`→`bool`, `uint8`/`int16`…→`int`, `float`/`double`→`double`, `string`→`String`, `T[]`→`List<T>`).
- Os nomes de classe usam o caminho completo (`_VssVehicleCabinDoorRow1`), então ramos
  com o mesmo nome em pais diferentes não colidem.
- `vssCatalog` guarda `type` (sensor/actuator/attribute), `unit`, `min`, `max`, `allowed` e `default`.
- Perfis são validados contra o spec mestre: um caminho inexistente, um override inválido
  ou um campo faltando **quebram o build**.

## Uso

Os builders são opt-in (`auto_apply: none`). Habilite no `build.yaml` do pacote consumidor:

```yaml
# vehicle_domain/build.yaml
targets:
  $default:
    builders:
      vss_gen:vss_tree:
        enabled: true          # part_of padrão: vss.dart

# vehicle_profiles/build.yaml
targets:
  $default:
    builders:
      vss_gen:vss_profile:
        enabled: true
        options:
          spec: package:vehicle_domain/src/vss/vehicle.vss.json
```

O arquivo indicado em `part_of` precisa importar `VssSignal`, `VssSignalMeta`,
`VssNodeType` (para a árvore) ou `VehicleProfile`, `DriverSide`, `VssMetaOverride` (para perfis).

## Estrutura

```
lib/
├── vss_gen.dart                   # Factories dos builders (lidas pelo build.yaml)
└── src/
    ├── vss_spec.dart              # Parser + validação do spec VSS
    ├── vss_tree_builder.dart      # *.vss.json -> árvore tipada + catálogo
    └── vss_profile_builder.dart   # *.profile.json -> const VehicleProfile
build.yaml                         # Declaração dos builders
```

## Testes

```
dart test
```
