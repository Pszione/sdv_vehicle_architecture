# Power modes & network management

How the simulated car decides **what exists right now**: which functions are available, which
control units are awake, and when the car goes to sleep. In a production vehicle this is the job
of the **Vehicle Mode Manager (VMM)** plus **network management (NM)** on every bus.

## Why real cars have it

| Benefit | Without power modes | With power modes |
|---|---|---|
| **One source of truth** | Each rule guesses the car's state from proxies (gear = P, cable connected...) | Rules ask one question: *is the car READY / OFF / CHARGING?* |
| **Correct availability** | Cruise control can be requested in a parked, switched-off car; the rule must catch it | The function simply does not exist outside READY: `Available when the vehicle is READY.` |
| **Simpler rules** | "Can't drive while plugged in" is checked on every gear request | Charging blocks READY once, at the source |
| **12 V battery life** | Nothing ever sleeps, nothing drains | ECUs sleep when unused; a stuck-awake ECU visibly drains the 12 V battery (a classic field issue) |
| **Realistic timing** | Every command acts instantly | HV pre-charge before READY, bus wake-up latency on a sleeping zone |
| **Lifecycle testing** | Only snapshots | Sequences: key approach → START → drive → park → walk away → sleep |

## Model

`PowerMode` is **derived** from COVESA signals, so the broker stays the single source of truth:

| PowerMode | Derived from |
|---|---|
| `SW UPDATE` | `Software.OTA.IsInstalling` |
| `CHARGING` | `TractionBattery.Charging.IsCharging` (checked before READY: contactors are closed while charging) |
| `READY` | `LowVoltageSystemState` ON/START **and** `TractionBattery.IsPowerConnected` |
| `ON` | `LowVoltageSystemState` ON/START, HV disconnected |
| `ACC` / `OFF` | `LowVoltageSystemState` ACC / OFF |
| `SLEEP` | `LowVoltageSystemState` LOCK (or UNDEFINED) |

A vehicle without `LowVoltageSystemState` (older trims, unit tests) has no power mode (`null`):
nothing is gated by availability, and safety rules still apply.

```
Driver / behaviors ─▶ PowerMode.Request (custom actuator)
   └─▶ CommandDispatcher ─▶ PowerModeRequestSafetyRule (key inside, brake, unplugged, stopped in P)
         └─▶ ZonalRoute: central / VEHICLE_MODE_MANAGER
               └─▶ VehicleModeManager ─▶ LowVoltageSystemState, IsPowerConnected, 12 V voltage
                     └─▶ powerModeProvider ─▶ CommandValidator availability, rules, NM, HMI chips
```

### Vehicle Mode Manager (`zonal_system/lib/src/power/vehicle_mode_manager.dart`)

| Request / event | What happens |
|---|---|
| READY | 12 V → START, HV **pre-charge** (300 ms), contactors close, 12 V → ON |
| ON / ACC | Contactors open, 12 V → ON / ACC |
| OFF after driving | **Retained accessory power** (ACC for 30 s) until a door opens |
| OFF otherwise | 12 V → OFF; if the key is away, **sleep** (LOCK) after 10 s |
| Key approaches / door opens | Wakes the car from LOCK to OFF |
| Every second | 12 V model: the DC-DC charges it to 14.1 V while HV is connected, awake ECUs drain it otherwise (Sentry drains faster) |

Times are shortened so the simulation is watchable (real cars use minutes).

### Network management (`zone_network_management.dart`)

Each zone's bus is `networkMode`, `prepareBusSleep` (500 ms grace) or `busSleep`, after AUTOSAR CanNm.
All zones are awake unless the car sleeps. While asleep, a zone stays up for its users: Sentry keeps
every zone awake (cameras), Camp/Dog Mode keep the central zone awake (HVAC). A **command to a
sleeping zone wakes it** and is delivered after the wake-up latency (150 ms), then the zone stays
awake for 5 s.

### Functional availability (`PowerModeAvailability`)

Checked by the `CommandValidator` **before** the safety rules: availability answers *"does this
function exist now?"*, the rules answer *"is it safe now?"*.

| Functions | Available in |
|---|---|
| Cruise control, lane keeping, hill descent | READY |
| Gear, ESC, chassis settings, drive mode, HUD | ON, READY |
| Climate, seats, battery preconditioning | ACC, ON, READY, CHARGING |
| Media, ambient light, V2L, Camp/Dog Mode | ACC, ON, READY |
| OTA install | OFF (and SW UPDATE, to cancel) |
| Locks, doors, openings, power requests | Always (body zones wake up) |
| **Securing the car**: PARK, parking brake, switching anything off | Always |

### Rules and behaviors

| Name | Role |
|---|---|
| `PowerModeRequestSafetyRule` | READY: key inside, brake ≥ 10%, cable unplugged. ON/ACC: key inside. OFF: stopped and in PARK. Nothing but OFF during an OTA install |
| `ReadyToShiftSafetyRule` | Leaving PARK requires READY |
| `ParkedModeSafetyRule` | Sentry/Camp/Dog/V2L also need the 12 V battery ≥ 11.8 V |
| `AutoPowerOffBehavior` (`AUTO_OFF`) | Driver seat empty + driver door open in PARK → power off |
| `WalkAwayLockBehavior` (`WALK_AWAY`) | Key gone **and** car off (either order) → lock every door |
| `AutoParkingBrakeBehavior` (`AUTO_EPB`) | Parking brake follows PARK |

## Try it

Simulator tab → **Key & power** card (power mode, 12 V voltage, zone bus states) and scenarios:

1. Boot: the car is **ON** (driver seated with the key). Try cruise control → `Available when the vehicle is READY.`
2. **Brake + START** → watch 12 V go START, then READY after the pre-charge.
3. **City driving**, then **Walk away**: auto power off, retained accessory, walk-away lock, and after
   10 s the zones fall asleep (grey dots).
4. While asleep, lock a door: the zone wakes (green dot) and the lock happens ~150 ms later.
5. **Weak 12 V battery** → arm Sentry: rejected. **Plugged in, low battery** → START: rejected.
6. **Ready for OTA** → install the update from the Vehicle tab → the car is in SW UPDATE and refuses READY.

## Gaps vs. a production ECU

- **Wake-up sources & partial networking**: real NM has wake-up reasons, partial networks
  (only the needed ECUs wake) and NM PDUs with a repeat-message phase; here a zone is just awake or asleep.
- **Power mode coordinators**: production cars split ignition/terminal states (KL15/KL30/KL50) and
  run a distributed state machine with timeouts and degradation; here the VMM is one notifier.
- **Signals from sleeping ECUs**: their data should become *not available*. That arrives with E2E
  signal status (see [e2e-signal-protection.md](e2e-signal-protection.md)).
- **12 V model**: linear, time-accelerated rates; no temperature, no state of health, no load shedding
  (switching off comfort loads as the voltage drops), no jump-start detection.
- **HV**: pre-charge is a fixed delay; no insulation monitoring, contactor weld check or HV interlock loop.
- **Keyless**: key location is a simulated sensor; no UWB/BLE ranging, relay-attack protection or second key.
- **Sleep timers** are seconds instead of minutes, and there is no wake-up counter / sleep-prevention diagnostics.
