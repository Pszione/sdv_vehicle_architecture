# IPC bridge (infotainment ⇄ digital cluster)

**Status: design only, not implemented.** Today each app runs its own vehicle core in-process.
This is how the cluster would read the *same* car as the infotainment.

## Goal

The infotainment keeps hosting the vehicle core (broker, dispatcher, zonal ECUs, simulators,
E2E gateway) and exposes a **WebSocket server**. The cluster connects as a **read-only client**.
Two iOS simulators share the Mac's network, so `ws://localhost:8765` works between them; on a
real iPad use the LAN IP and declare `NSLocalNetworkUsageDescription`.

```
infotainment (core host)                               digital_cluster (client)
  VssBroker ── SignalStatusRegistry                      RemoteVssBroker  (overrides vssBrokerProvider)
      │                │                                 RemoteStatusRegistry (overrides signalStatusRegistryProvider)
      └── BridgeServer ┴── snapshot / delta / heartbeat ──▶ BridgeClient
              ▲                                              │
              └──────────── subscribe / (command: hmi role only) ◀┘
```

## Protocol (JSON first, binary later)

```
client → server   hello       {role: cluster|hmi, protocolVersion}
                  subscribe   {paths: [...]}          // the cluster asks only for what it draws
                  command     {requestId, path, value, source}   // hmi role only; rejected for the cluster
server → client   snapshot    {seq, profileId, values, statuses} // on connect and on resync
                  delta       {seq, values: {...}, statuses: {...}} // grouped per frame (~16 ms)
                  commandResult {requestId, status, message}
both ways         heartbeat   every 500 ms
```

- **Sequence numbers**: a gap in `seq` makes the client request a resync (new snapshot).
- **Heartbeat**: if it stops, the client marks every signal `stale`; the cluster then shows `--`
  through the same status path as an E2E fault. A dead link looks exactly like a dead ECU.
- **Roles**: the server enforces that the cluster cannot send commands (like SOME/IP service
  access control). The cluster package does not even depend on the dispatcher.
- **Batching**: deltas are coalesced per frame, so a 30 Hz ADAS stream plus 10 Hz sensors cost one
  message per frame, not one per signal.

## Code (new pure-Dart package `packages/vehicle_bridge`)

| Piece | Role |
|---|---|
| `bridge_messages.dart` | Sealed message classes + JSON codec, versioned |
| `BridgeServer` | Listens to `vssBrokerProvider` and `signalStatusRegistryProvider`, tracks subscriptions per client, sends batched deltas, answers commands through the `CommandDispatcher` for the `hmi` role |
| `BridgeClient` | Connects, resubscribes and resyncs on reconnect, heartbeat supervision |
| `RemoteVssBroker`, `RemoteStatusRegistry` | Notifiers fed by the client; the cluster overrides the two providers with them |

Because `vssValueProvider`, `ref.watchSignal`, `signalStatusProvider` and the telltale/message
providers sit **on top of** those two providers, no cluster widget changes: it cannot tell whether
the broker is local or remote. The standalone `DemoDriveBar` and the cluster's own core go away.

## Benefits

- **One car, many displays**: the cluster, a HUD, a rear-seat screen or a phone app read the same
  state, with no duplicated simulation.
- **Fault isolation**: an infotainment crash does not freeze the cluster silently; the heartbeat
  turns it into an explicit *signals unavailable* state.
- **Least privilege**: the cluster cannot command the car, by protocol and by dependency graph.
- **Realistic deployment**: production cars run cluster and infotainment on separate partitions or
  SoCs (hypervisor, or two chips) connected by SOME/IP or DDS.

## Production equivalents and next steps

- The role of the bridge is played by **SOME/IP** (service discovery + events), **DDS**, or a
  VSS-native databroker such as **Eclipse KUKSA.val** (gRPC). Speaking the KUKSA.val API would let
  real VSS tooling (CAN feeders, cloud connectors) plug in directly.
- Later, move the core into a headless `apps/vehicle_core` (pure-Dart CLI, the "vehicle computer")
  and make **both** HMIs clients: closest to a real car.
- Security for anything beyond a dev LAN: TLS with mutual authentication, and SecOC-style
  authentication for safety-relevant signals carried over the bridge.
