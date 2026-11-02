# E2E signal protection & signal status

Safety rules are only as good as their inputs. This feature makes the gateway **prove** that a
safety-relevant signal is fresh, intact and from the right sender before any rule may use it,
after **AUTOSAR End-to-End (E2E) protection** (Profiles 1/2) and COM deadline monitoring.

## Why real cars have it

The killer failure is a sender that is *alive but frozen*: the chassis ECU's task hangs, its CAN
driver keeps resending the last buffer — **3 km/h** — while the car does 80. Without E2E,
`OpeningWhileMovingSafetyRule` reads 3 km/h and **approves opening the tailgate on the highway**.

| Benefit | How |
|---|---|
| **Catches every communication fault ISO 26262 lists** | Corruption (CRC), repetition and frozen senders (counter), loss and re-ordering (counter jumps), delay and silence (deadline), masquerade and wrong routing (Data ID inside the CRC) |
| **Lets non-safety software carry safety data** | Only the two ends (protector and checker) need ASIL integrity. CAN drivers, SOME/IP stacks, the zonal gateway's routing and the queues can stay QM — "freedom from interference" on the communication path |
| **End to end, through gateways** | Zonal architectures re-route and re-pack frames in the central gateway; the protection survives that, unlike per-link checks |
| **Honest data, fail-safe rules** | A rule never sees a frozen or corrupted value: it sees *unavailable* and must state what it does then (reject, treat speed as "moving") |
| **Stable status** | The E2E state machine needs several bad frames to declare INVALID and several good ones to recover, so one bit flip does not make the signal flicker |
| **Honest HMI** | The cluster shows `--` for an invalid speed instead of a frozen number |

E2E is about **safety, not security**: a CRC can be forged. Protection against attackers is
SecOC (MAC + freshness value); production cars layer both.

## How it works here

```
Sensor ECU (simulator)                         Central gateway (domain)
  report(Speed, 80) ─▶ E2eTransmitter            E2eReceiver
     protect: counter++ , CRC-8(DataID,ctr,v) ──▶  check: CRC? counter step?   ─▶ E2eStateMachine (window)
     sent on change + every 100 ms                 deadline monitoring (400 ms)    VALID / INVALID / N/A / STALE
     [fault injection on the link]                    │                               │
                                                      └─ VALID only ─▶ VssBroker.publish   SignalStatusRegistry
                                                                                           │
   SignalReader.read() returns null unless VALID ◀─────────────────────────────────────────┘
   └─▶ every SafetyRule, behavior and canDispatch; the HMI uses ref.watchSignalStatus()
```

| Piece | File | Role |
|---|---|---|
| `E2eProtector` / `E2eChecker` | `vehicle_domain/lib/src/e2e/e2e_protection.dart` | 4-bit alive counter, CRC-8 SAE J1850 over Data ID + counter + payload (Profile 1). Checker results: OK, OK_SOME_LOST (jump ≤ 2), REPEATED, WRONG_SEQUENCE, ERROR |
| `E2eStateMachine` | same | NODATA → INIT → VALID ⇄ INVALID over a window of 3 results |
| `E2eProtectedSignals` | `e2e_protected_signals.dart` | Protected signals and their Data IDs: speed, brake pedal, steering angle, charging cable, crash, lead distance, lane offset, lane curvature. Cycle 100 ms, timeout 400 ms |
| `E2eReceiver` | `e2e/providers/e2e_receiver.dart` | Gateway side: checks, state machine, deadline monitoring, publishes valid values, logs `SIGNAL` entries |
| `SignalStatusRegistry` / `signalStatusProvider` | `e2e/providers/signal_status_provider.dart` | Status per signal, granular for the UI |
| `E2eTransmitter` + `E2eFault` | `vehicle_simulators/lib/src/e2e_transmitter.dart` | Sensor side, with injectable faults |
| `FailSafe` | `safety_rules/domain/fail_safe.dart` | Shared rejections when an input is unavailable |

**Status vs. power modes**: when the car sleeps, the sensor ECUs stop sending on purpose; the
gateway marks their signals *not available* and suspends deadline monitoring instead of
reporting STALE. On wake-up the first good frames make them VALID again.

**Only protected signals have a status**: everything else is considered valid. Supervision starts
with the first frame, so unit tests that publish straight to the broker are unaffected.

### Fault injection

| Fault (Simulator → *E2E signal faults*) | What the link does | Detected as |
|---|---|---|
| Frozen sender | Resends the last frame (same counter, stale value) | REPEATED → INVALID |
| Bit flip | Corrupts every frame | ERROR (CRC) → INVALID |
| Frame loss | Delivers 1 frame out of 3 | WRONG_SEQUENCE → INVALID |
| Sender dead | Sends nothing | Deadline → STALE |
| Wrong sender | Frames built with another Data ID | ERROR (CRC) → INVALID |

## Try it

1. Scenario **Highway** (130 km/h, READY, DRIVE).
2. *E2E signal faults* → `Vehicle.Speed` → **Frozen sender**. Report 3 km/h with the speed slider:
   nothing reaches the broker, the status turns **INVALID** and a purple `SIGNAL` entry appears.
3. Try to open the tailgate: *"Vehicle speed unavailable. Not allowed until it is valid again."*
4. Back to **None**: three good frames later the speed is **VALID** again (`Signal recovered`).
5. **Walk away** and wait 10 s: every protected signal goes **N/A** (senders asleep), not STALE.

## Gaps vs. a production ECU

- **Profiles**: one simplified Profile 1 (CRC-8, 4-bit counter, Data ID in the CRC). Production
  uses per-PDU profiles (P4/P5/P7/P11/P22) with 16/32-bit CRCs, Data ID nibbles, length fields and
  `MaxDeltaCounter` per signal, configured from the ARXML communication matrix.
- **Serialization**: the CRC covers a Dart value serialized ad hoc; real E2E covers the exact
  packed PDU bytes (signal layout, endianness, update bits).
- **Status per PDU, not per signal**: real E2E protects a frame carrying several signals; one
  failure invalidates all of them. Here each signal is its own "frame".
- **Timing**: 100 ms cycles instead of 10–20 ms; deadline monitoring is tick-based (50 ms).
- **Degradation**: rules reject when an input is unavailable. Real systems also substitute values
  (redundant wheel-speed sources, plausibility between ESC and inverter speed), enter limp modes
  and store DTCs with freeze frames.
- **No SecOC**: no authentication or freshness; a malicious ECU that computes the CRC is accepted.
- **Sender side**: the transmitter is simulated; a real sensor ECU also needs its own safety
  mechanisms (watchdog, RAM/ROM checks) so it does not produce *valid frames with wrong data*.
