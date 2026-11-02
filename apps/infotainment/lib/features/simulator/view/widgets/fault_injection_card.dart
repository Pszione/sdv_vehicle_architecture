import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';
import 'package:zonal_system/zonal_system.dart';

/// Injects faults into the sunroof actuator. The fault shows up on the next movement.
class FaultInjectionCard extends ConsumerStatefulWidget {
  const FaultInjectionCard({super.key});

  @override
  ConsumerState<FaultInjectionCard> createState() => _FaultInjectionCardState();
}

class _FaultInjectionCardState extends ConsumerState<FaultInjectionCard> {
  static const _labels = {
    ActuatorFaultType.none: 'None',
    ActuatorFaultType.mechanicalJam: 'Jam at 50%',
    ActuatorFaultType.hardwareTimeout: 'Timeout',
  };

  // The fault lives inside the simulated actuator, so the selection is kept locally.
  ActuatorFaultType _fault = ActuatorFaultType.none;

  @override
  Widget build(BuildContext context) {
    return VehicleFeatureGuard(
      signal: Vss.Vehicle.Cabin.Sunroof.Position,
      child: VehicleControlCard(
        icon: Icons.bug_report_outlined,
        title: 'Sunroof fault injection',
        child: SegmentedButton<ActuatorFaultType>(
          segments: [
            for (final MapEntry(key: fault, value: label) in _labels.entries)
              ButtonSegment(value: fault, label: Text(label)),
          ],
          selected: {_fault},
          onSelectionChanged: (selection) {
            setState(() => _fault = selection.first);
            ref.read(centralZoneControllerProvider.notifier).injectSunroofFault(_fault);
          },
        ),
      ),
    );
  }
}
