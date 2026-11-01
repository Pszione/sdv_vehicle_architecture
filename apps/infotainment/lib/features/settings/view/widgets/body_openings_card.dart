import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Tailgate, frunk, charge port flap and charging cable lock.
class BodyOpeningsCard extends ConsumerWidget {
  const BodyOpeningsCard({super.key});

  static const _tailgateOpenAngle = 90.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tailgate = Vss.Vehicle.Body.Trunk.PowerOpeningAngle;
    final flap = Vss.Vehicle.Powertrain.TractionBattery.Charging.ChargePortFlap;
    final isTailgateOpen = (ref.watchSignal(tailgate) ?? 0) > 0;
    final isFlapOpen = ref.watchSignal(flap) == ChargePortFlapState.open;

    return VehicleControlCard(
      icon: Icons.sensor_door_outlined,
      title: 'Openings & charging',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OpeningButton(
            signal: tailgate,
            label: 'Power tailgate',
            isOpen: isTailgateOpen,
            openValue: _tailgateOpenAngle,
            closedValue: 0.0,
          ),
          VehicleCommandSwitch(
            signal: Vss.Vehicle.Body.Trunk.Front.IsOpen,
            title: 'Frunk open',
            source: infotainmentCommandSource,
          ),
          _OpeningButton(
            signal: flap,
            label: 'Charge port flap',
            isOpen: isFlapOpen,
            openValue: ChargePortFlapState.open,
            closedValue: ChargePortFlapState.closed,
          ),
          VehicleCommandSwitch(
            signal: Vss.Vehicle.Powertrain.TractionBattery.Charging.IsChargingCableLocked,
            title: 'Charging cable locked',
            source: infotainmentCommandSource,
            precheckValue: false,
          ),
        ],
      ),
    );
  }
}

class _OpeningButton<T extends Object> extends ConsumerWidget {
  const _OpeningButton({
    required this.signal,
    required this.label,
    required this.isOpen,
    required this.openValue,
    required this.closedValue,
  });

  final VssSignal<T> signal;
  final String label;
  final bool isOpen;
  final T openValue;
  final T closedValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VehicleFeatureGuard(
      signal: signal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(label)),
                Text(isOpen ? 'OPEN' : 'CLOSED', style: TextStyle(color: isOpen ? Colors.amber : Colors.white54)),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => ref.dispatchCommand(
                    context,
                    VehicleCommand(
                      signal: signal,
                      value: isOpen ? closedValue : openValue,
                      source: infotainmentCommandSource,
                    ),
                  ),
                  child: Text(isOpen ? 'CLOSE' : 'OPEN'),
                ),
              ],
            ),
            if (!isOpen)
              SafetyPrecheckBanner(
                command: VehicleCommand(signal: signal, value: openValue, source: infotainmentCommandSource),
              ),
          ],
        ),
      ),
    );
  }
}
