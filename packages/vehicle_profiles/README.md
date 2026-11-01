# vehicle_profiles

**Camada 4: Matriz de capacidades dos modelos.** Dart puro. Cada trim do veículo é um
`*.profile.json` que lista os sinais que o modelo tem, gerado como `const VehicleProfile`
e **validado contra o spec mestre durante o build**.

Assim, todo o código compila para qualquer modelo: o que muda entre modelos é dado, não código.

## Perfis de fábrica

| Perfil | Const | Sinais |
|---|---|---|
| `entry.profile.json` | `entryProfile` | Básico: velocidade e porta do motorista |
| `premium.profile.json` | `premiumProfile` | Básico + teto solar |
| `luxury_ev_suv.profile.json` | `luxuryEvSuvProfile` | EV SUV completo (ADAS, 4x4, HVAC quadrizona…) |
| `flagship.profile.json` | `flagshipProfile` | Spec completo (Sentry, Dog/Valet Mode, V2L, OTA…) |

`factoryProfiles` expõe todos, em ordem, para seletores de HMI.

## Formato

```json
{
  "id": "luxury_ev_suv",
  "trimName": "EV SUV Luxury",
  "driverSide": "left",
  "signals": ["Vehicle.Speed", "Vehicle.Cabin.Sunroof.Position"],
  "overrides": {
    "Vehicle.Chassis.Suspension.Height": { "allowed": ["LOW", "NORMAL", "HIGH"] }
  }
}
```

`overrides` aceita `min`, `max` e `allowed`, como um overlay do vss-tools.

## Criar um modelo

1. Crie `lib/src/profiles/<id>.profile.json`.
2. Declare `part '<id>.profile.g.dart';` em `factory_profiles.dart` e adicione o perfil em `factoryProfiles`.
3. Rode `dart run build_runner build`.
4. No app do modelo, use `initialVehicleProfileProvider.overrideWithValue(<id>Profile)`.
