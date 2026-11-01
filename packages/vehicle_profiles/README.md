# vehicle_profiles

**Layer 4: Model capability matrix.** Pure Dart. Every vehicle trim is a `*.profile.json`
listing the signals that model has, generated as a `const VehicleProfile` and
**validated against the master spec at build time**.

All code compiles for every model: what changes between models is data, not code.

## Factory profiles

| Profile | Const | Signals |
|---|---|---|
| `entry.profile.json` | `entryProfile` | Basic: speed and driver door |
| `premium.profile.json` | `premiumProfile` | Basic + sunroof |
| `luxury_ev_suv.profile.json` | `luxuryEvSuvProfile` | Full EV SUV (ADAS, 4x4, quad-zone HVAC, outside temperature…) |
| `flagship.profile.json` | `flagshipProfile` | Full spec (Sentry, Dog/Valet Mode, V2L, OTA…) |

`factoryProfiles` exposes all of them, in order, for HMI selectors.

## Format

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

`overrides` accepts `min`, `max` and `allowed`, like a vss-tools overlay.

## Adding a model

1. Create `lib/src/profiles/<id>.profile.json`.
2. Declare `part '<id>.profile.g.dart';` in `factory_profiles.dart` and add the profile to `factoryProfiles`.
3. Run `dart run build_runner build`.
4. In the model's app, use `initialVehicleProfileProvider.overrideWithValue(<id>Profile)`.
