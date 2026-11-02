# vehicle_ui_kit

**Shared design system** for the HMIs (infotainment and cluster). Depends only on `vehicle_domain`.

## Components

| Component | Role |
|---|---|
| `ref.watchSignal(Vss...)` | Watches **one** typed signal; the widget only rebuilds when it changes |
| `ref.watchSignalStatus(signal)` | Health of an E2E-protected signal (VALID, N/A, STALE, INVALID) |
| `ref.dispatchCommand(context, command)` | Sends through the `CommandDispatcher` and shows the reason (SnackBar) when rejected |
| `SafetyPrecheckBanner(command)` | Warns ahead, with the blocking rule's message, that a command would be rejected |
| `VehicleCommandSwitch` | Switch bound to a boolean actuator: command + pre-check, hidden if unsupported |
| `VehicleControlCard` | Common card shell: icon, title, status and content |
| `VehicleFeatureGuard` | Shows a widget only if the signal exists in the active profile (or a `fallback`) |
| `CarProfileSelectorBar` | Switches the profile live (simulation tool) and shows the power mode |
| `PowerModeChip` | Current power mode (OFF, ACC, ON, READY, CHARGING...) |

## Example

```dart
class DiffLockButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffLock = Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked;
    final isLocked = ref.watchSignal(diffLock) ?? false;

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => ref.dispatchCommand(context, VehicleCommand(signal: diffLock, value: !isLocked)),
          child: Text(isLocked ? 'RELEASE' : 'ENGAGE LOCK'),
        ),
        if (!isLocked) SafetyPrecheckBanner(command: VehicleCommand(signal: diffLock, value: true)),
      ],
    );
  }
}
```

## Widget rules

- Never watch the whole `VssBroker` map: use `watchSignal`, or `.select` for profile fields.
- The UI never writes to the broker; it only sends `VehicleCommand`s and shows confirmed telemetry.
- Controls stay enabled; the dispatcher has the final word and the banner is only a heads-up.
