import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Stationary modes: Dog, Camp, Sentry and vehicle-to-load.
class CabinModesCard extends ConsumerWidget {
  const CabinModesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentry = Vss.Vehicle.Cabin.Sentry.Mode;
    final isSentryArmed = ref.watchSignal(sentry) == SentryMode.armed;

    return VehicleControlCard(
      icon: Icons.local_parking,
      title: 'Parked modes',
      child: Column(
        children: [
          VehicleCommandSwitch(
            signal: Vss.Vehicle.Cabin.HVAC.DogMode.IsEnabled,
            title: 'Dog Mode',
            subtitle: 'Keeps the cabin comfortable for pets',
            source: infotainmentCommandSource,
          ),
          VehicleCommandSwitch(
            signal: Vss.Vehicle.Cabin.HVAC.CampMode.IsEnabled,
            title: 'Camp Mode',
            subtitle: 'Climate and power on overnight',
            source: infotainmentCommandSource,
          ),
          VehicleFeatureGuard(
            signal: sentry,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Sentry Mode'),
                  subtitle: const Text('Cameras watch the surroundings'),
                  value: isSentryArmed,
                  onChanged: (armed) => ref.dispatchCommand(
                    context,
                    VehicleCommand(
                      signal: sentry,
                      value: armed ? SentryMode.armed : SentryMode.off,
                      source: infotainmentCommandSource,
                    ),
                  ),
                ),
                if (!isSentryArmed)
                  SafetyPrecheckBanner(
                    command: VehicleCommand(signal: sentry, value: SentryMode.armed, source: infotainmentCommandSource),
                  ),
              ],
            ),
          ),
          VehicleCommandSwitch(
            signal: Vss.Vehicle.Powertrain.V2L.IsExportingPower,
            title: 'Vehicle-to-load (V2L)',
            subtitle: 'Power external devices from the battery',
            source: infotainmentCommandSource,
          ),
        ],
      ),
    );
  }
}
