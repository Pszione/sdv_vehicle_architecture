import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// **Standalone demo only**: simulated driver inputs (start button, stalks, drives, faults),
/// so the cluster can be exercised without the infotainment. Everything goes through the
/// simulators, which use the dispatcher like any other source; the cluster widgets themselves
/// never send a command. Remove once the cluster runs on the IPC bridge.
class DemoDriveBar extends ConsumerWidget {
  const DemoDriveBar({super.key});

  static const _source = 'CLUSTER_DEMO';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = ref.read(telemetrySimulatorProvider.notifier);
    final driving = ref.read(drivingSimulatorProvider.notifier);
    final activeDrive = ref.watch(drivingSimulatorProvider);
    final mode = ref.watch(powerModeProvider);
    final lights = Vss.Vehicle.Body.Lights;
    final adas = Vss.Vehicle.ADAS;

    // Watch for the button states; read (never watch) inside callbacks.
    bool isOn(VssSignal<bool> signal) => ref.watchSignal(signal) ?? false;
    bool currentlyOn(VssSignal<bool> signal) => (ref.read(vssValueProvider(signal)) as bool?) ?? false;
    void command<T extends Object>(VssSignal<T> signal, T value) =>
        _toast(context, sim.command(signal, value, from: _source).message);
    void toggle(VssSignal<bool> signal) => command(signal, !currentlyOn(signal));

    Future<void> drive(DriveProfile profile) async {
      if (mode != PowerMode.ready) await sim.apply(SimulationScenario.startReady);
      sim.report(Vss.Vehicle.Chassis.Brake.PedalPosition, 100);
      command(Vss.Vehicle.Powertrain.Transmission.SelectedGear, Gear.drive);
      sim.report(Vss.Vehicle.Chassis.Brake.PedalPosition, 0);
      driving.start(profile);
    }

    void park() {
      driving.stop();
      sim.report(Vss.Vehicle.Speed, 0.0);
      command(Vss.Vehicle.Powertrain.Transmission.SelectedGear, Gear.park);
    }

    final speed = Vss.Vehicle.Speed;
    // Rebuilds when the injected fault changes the speed status.
    ref.watchSignalStatus(speed);
    final isSpeedFrozen = sim.e2eFaultOf(speed) == E2eFault.frozenSender;

    return Container(
      color: const Color(0xFF0B0C0E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('DEMO  ', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          _DemoButton(
            label: mode == PowerMode.ready ? 'Power off' : 'Brake + START',
            onPressed: () {
              if (mode == PowerMode.ready) {
                park();
                command(Vss.Vehicle.PowerMode.Request, PowerModeRequest.off);
              } else {
                sim.apply(SimulationScenario.startReady);
              }
            },
          ),
          for (final profile in DriveProfile.presets)
            _DemoButton(label: profile.name, isActive: activeDrive == profile, onPressed: () => drive(profile)),
          _DemoButton(label: 'Park', onPressed: park),
          const _Divider(),
          _DemoButton(
            label: 'ACC',
            isActive: isOn(adas.CruiseControl.IsActive),
            onPressed: () {
              final current = ref.read(vssValueProvider(speed)) as double? ?? 0;
              if (!currentlyOn(adas.CruiseControl.IsActive) && current >= 30) {
                command(adas.CruiseControl.SpeedSet, (current / 5).round() * 5.0);
              }
              toggle(adas.CruiseControl.IsActive);
            },
          ),
          _DemoButton(
            label: 'Lane keep',
            isActive: isOn(adas.LaneKeepingAssist.IsEnabled),
            onPressed: () => toggle(adas.LaneKeepingAssist.IsEnabled),
          ),
          _DemoButton(
            label: '◀',
            isActive: isOn(lights.DirectionIndicator.Left.IsSignaling),
            onPressed: () => toggle(lights.DirectionIndicator.Left.IsSignaling),
          ),
          _DemoButton(
            label: '▶',
            isActive: isOn(lights.DirectionIndicator.Right.IsSignaling),
            onPressed: () => toggle(lights.DirectionIndicator.Right.IsSignaling),
          ),
          _DemoButton(
            label: 'Hazards',
            isActive: isOn(lights.Hazard.IsSignaling),
            onPressed: () => toggle(lights.Hazard.IsSignaling),
          ),
          _DemoButton(
            label: 'High beam',
            isActive: isOn(lights.Beam.High.IsOn),
            onPressed: () => toggle(lights.Beam.High.IsOn),
          ),
          const _Divider(),
          _DemoButton(
            label: 'Door',
            isActive: isOn(VehicleGroups.driverDoor.open),
            onPressed: () =>
                sim.operateManually(VehicleGroups.driverDoor.open, !currentlyOn(VehicleGroups.driverDoor.open)),
          ),
          _DemoButton(
            label: 'Unbelt',
            isActive: !(ref.watchSignal(VehicleGroups.driverSeat.belted) ?? true),
            onPressed: () {
              sim.report(VehicleGroups.driverSeat.occupancy, SeatOccupancy.occupied);
              sim.report(VehicleGroups.driverSeat.belted, !currentlyOn(VehicleGroups.driverSeat.belted));
            },
          ),
          _DemoButton(
            label: 'Tire',
            isActive: isOn(Vss.Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.IsPressureLow),
            onPressed: () {
              final tire = Vss.Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.IsPressureLow;
              sim.report(tire, !currentlyOn(tire));
            },
          ),
          _DemoButton(
            label: 'Frozen speed',
            isActive: isSpeedFrozen,
            onPressed: () => sim.injectE2eFault(speed, isSpeedFrozen ? E2eFault.none : E2eFault.frozenSender),
          ),
        ],
      ),
    );
  }

  static void _toast(BuildContext context, String? message) {
    if (message == null) return;
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, required this.onPressed, this.isActive = false});

  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        textStyle: const TextStyle(fontSize: 12),
        foregroundColor: isActive ? Colors.black : Colors.white70,
        backgroundColor: isActive ? Colors.white : Colors.transparent,
        side: const BorderSide(color: Colors.white24),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 24, margin: const EdgeInsets.symmetric(horizontal: 4), color: Colors.white24);
}
