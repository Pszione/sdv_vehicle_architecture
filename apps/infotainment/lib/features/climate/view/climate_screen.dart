import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import 'widgets/cabin_view.dart';
import 'widgets/climate_control_bar.dart';
import 'widgets/climate_status_bar.dart';
import 'widgets/zone_temperature_control.dart';

/// "Climate" tab: full-screen 3-zone climate (driver, passenger, rear), inspired by
/// Tesla (top-down cabin and airflow), Rivian/Porsche (large zone temperatures).
class ClimateScreen extends ConsumerWidget {
  const ClimateScreen({super.key});

  static const _sideBySideMinWidth = 760.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRhd = ref.watch(activeVehicleProfileProvider.select((p) => p.driverSide == DriverSide.right));
    final stations = VehicleGroups.hvacStations;
    final driver = ZoneTemperatureControl(label: 'Driver', stations: [stations[0]]);
    final passenger = ZoneTemperatureControl(label: 'Passenger', stations: [stations[1]]);
    final rear = ZoneTemperatureControl(label: 'Rear', stations: VehicleGroups.rearHvacStations, axis: Axis.horizontal);
    // Zones are placed physically: the driver is on the left of a LHD car.
    final (left, right) = isRhd ? (passenger, driver) : (driver, passenger);

    return VehicleFeatureGuard(
      signal: stations.first.temperature,
      fallback: const Center(child: Text('Climate control is not available on this vehicle.')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < _sideBySideMinWidth) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const ClimateStatusBar(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: left),
                    Expanded(child: right),
                  ],
                ),
                const SizedBox(height: 360, child: Center(child: CabinView())),
                rear,
                const SizedBox(height: 16),
                const ClimateControlBar(),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const ClimateStatusBar(),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 200, child: left),
                      Expanded(
                        child: Column(
                          children: [
                            const Expanded(child: Center(child: CabinView())),
                            rear,
                          ],
                        ),
                      ),
                      SizedBox(width: 200, child: right),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const ClimateControlBar(),
              ],
            ),
          );
        },
      ),
    );
  }
}
