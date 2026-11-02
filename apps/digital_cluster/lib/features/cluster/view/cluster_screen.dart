import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../../../core/cluster_colors.dart';
import '../../../dev/demo_drive_bar.dart';
import 'widgets/adas_view.dart';
import 'widgets/battery_status.dart';
import 'widgets/gear_indicator.dart';
import 'widgets/message_center_panel.dart';
import 'widgets/power_meter.dart';
import 'widgets/speed_readout.dart';
import 'widgets/telltale_bar.dart';
import 'widgets/trip_info.dart';

/// Instrument cluster for an iPad in landscape, in the style of current Tesla/Rivian
/// clusters: near-black, one big speed, a live ADAS road view in the center, and only the
/// telltales that are on.
///
/// Read-only: it never sends a vehicle command. The demo bar at the bottom simulates the
/// driver's inputs while the cluster runs standalone.
class ClusterScreen extends ConsumerWidget {
  const ClusterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(powerModeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: switch (mode) {
                PowerMode.off || PowerMode.sleep => const _VehicleOffView(),
                PowerMode.charging => const _ChargingView(),
                _ => const _DrivingLayout(),
              },
            ),
            const DemoDriveBar(),
          ],
        ),
      ),
    );
  }
}

class _DrivingLayout extends StatelessWidget {
  const _DrivingLayout();

  static const _sideWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Column(
        children: [
          TelltaleBar(),
          SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _sideWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            GearIndicator(),
                            SizedBox(width: 24),
                            Expanded(child: SpeedReadout()),
                          ],
                        ),
                      ),
                      PowerMeter(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(child: AdasView()),
                SizedBox(
                  width: _sideWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BatteryStatus(),
                      SizedBox(height: 16),
                      Expanded(child: MessageCenterPanel()),
                      TripInfo(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleOffView extends StatelessWidget {
  const _VehicleOffView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_filled, size: 160, color: Color(0x14FFFFFF)),
          SizedBox(height: 16),
          Text('Vehicle off', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
          SizedBox(height: 8),
          Text('Press the brake and START', style: TextStyle(color: ClusterColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ChargingView extends StatelessWidget {
  const _ChargingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, size: 72, color: ClusterColors.regen),
          SizedBox(height: 8),
          Text('Charging', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
          SizedBox(height: 24),
          BatteryStatus(isLarge: true),
        ],
      ),
    );
  }
}
