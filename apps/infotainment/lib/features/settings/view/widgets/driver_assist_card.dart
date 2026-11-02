import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Driver assists: adaptive cruise (with set speed), lane keeping and hill descent.
class DriverAssistCard extends ConsumerStatefulWidget {
  const DriverAssistCard({super.key});

  @override
  ConsumerState<DriverAssistCard> createState() => _DriverAssistCardState();
}

class _DriverAssistCardState extends ConsumerState<DriverAssistCard> {
  double? _dragSetSpeed;

  @override
  Widget build(BuildContext context) {
    final adas = Vss.Vehicle.ADAS;
    final setSpeed = ref.watchSignal(adas.CruiseControl.SpeedSet) ?? 100;
    final limiter = ref.watchSignal(adas.SpeedLimiter.SetSpeed);

    return VehicleControlCard(
      icon: Icons.assistant_navigation,
      title: 'Driver assistance',
      status: limiter == null ? null : 'LIMIT ${limiter.round()} km/h',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VehicleCommandSwitch(
            signal: adas.CruiseControl.IsActive,
            title: 'Adaptive cruise control',
            source: infotainmentCommandSource,
          ),
          VehicleFeatureGuard(
            signal: adas.CruiseControl.SpeedSet,
            child: Row(
              children: [
                const Text('Set speed'),
                Expanded(
                  child: Slider(
                    value: _dragSetSpeed ?? setSpeed,
                    min: 30,
                    max: 180,
                    divisions: 15,
                    label: '${(_dragSetSpeed ?? setSpeed).round()} km/h',
                    onChanged: (value) => setState(() => _dragSetSpeed = value),
                    onChangeEnd: (value) {
                      setState(() => _dragSetSpeed = null);
                      ref.dispatchCommand(
                        context,
                        VehicleCommand(signal: adas.CruiseControl.SpeedSet, value: value, source: infotainmentCommandSource),
                      );
                    },
                  ),
                ),
                Text('${setSpeed.round()} km/h'),
              ],
            ),
          ),
          VehicleCommandSwitch(
            signal: adas.LaneKeepingAssist.IsEnabled,
            title: 'Lane keeping assist',
            source: infotainmentCommandSource,
          ),
          VehicleCommandSwitch(
            signal: adas.HillDescentControl.IsEnabled,
            title: 'Hill descent control',
            source: infotainmentCommandSource,
          ),
        ],
      ),
    );
  }
}
