import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';
import 'climate_colors.dart';

/// Bottom climate bar: AUTO, A/C, recirculation, defrost, SYNC, rear lock,
/// fan speed and airflow direction.
class ClimateControlBar extends ConsumerStatefulWidget {
  const ClimateControlBar({super.key});

  @override
  ConsumerState<ClimateControlBar> createState() => _ClimateControlBarState();
}

class _ClimateControlBarState extends ConsumerState<ClimateControlBar> {
  static const _distributions = {
    AirDistribution.up: ('Face', Icons.north_west),
    AirDistribution.middle: ('Face + feet', Icons.swap_vert),
    AirDistribution.down: ('Feet', Icons.south_west),
  };

  double? _dragFan;

  void _send<T extends Object>(VssSignal<T> signal, T value) =>
      ref.dispatchCommand(context, VehicleCommand(signal: signal, value: value, source: infotainmentCommandSource));

  void _setFan(int percent) {
    // Moving the fan by hand leaves AUTO, as in production cars.
    if (ref.read(vssValueProvider(Vss.Vehicle.Cabin.HVAC.IsAutoActive)) == true) {
      _send(Vss.Vehicle.Cabin.HVAC.IsAutoActive, false);
    }
    for (final station in VehicleGroups.hvacStations) {
      _send(station.fanSpeed, percent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hvac = Vss.Vehicle.Cabin.HVAC;
    final stations = VehicleGroups.hvacStations;
    final fan = [for (final s in stations) ref.watchSignal(s.fanSpeed) ?? 0].reduce(math.max);
    final distribution = ref.watchSignal(stations.first.airDistribution);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _ClimateToggle(signal: hvac.IsAutoActive, icon: Icons.brightness_auto, label: 'AUTO'),
                _ClimateToggle(signal: hvac.IsAirConditioningActive, icon: Icons.ac_unit, label: 'A/C'),
                _ClimateToggle(signal: hvac.IsRecirculationActive, icon: Icons.autorenew, label: 'Recirculate'),
                _ClimateToggle(signal: hvac.IsFrontDefrosterActive, icon: Icons.blur_on, label: 'Max defrost'),
                _ClimateToggle(signal: hvac.IsRearDefrosterActive, icon: Icons.grid_on, label: 'Rear defrost'),
                _ClimateToggle(signal: hvac.IsSyncActive, icon: Icons.link, label: 'Sync'),
                _ClimateToggle(signal: hvac.IsRearControlLocked, icon: Icons.lock_outline, label: 'Lock rear'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.air),
                Expanded(
                  child: Slider(
                    value: _dragFan ?? fan.toDouble(),
                    max: 100,
                    divisions: 10,
                    label: '${(_dragFan ?? fan).round()}%',
                    onChanged: (value) => setState(() => _dragFan = value),
                    onChangeEnd: (value) {
                      setState(() => _dragFan = null);
                      _setFan(value.round());
                    },
                  ),
                ),
                SizedBox(width: 48, child: Text(fan == 0 ? 'OFF' : '$fan%', textAlign: TextAlign.end)),
                const SizedBox(width: 16),
                VehicleFeatureGuard(
                  signal: stations.first.airDistribution,
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: [
                      for (final MapEntry(key: value, value: (label, icon)) in _distributions.entries)
                        ButtonSegment(value: value, icon: Icon(icon), tooltip: label),
                    ],
                    selected: {?distribution},
                    emptySelectionAllowed: true,
                    onSelectionChanged: (selection) {
                      for (final station in VehicleGroups.frontHvacStations) {
                        _send(station.airDistribution, selection.first);
                      }
                    },
                  ),
                ),
              ],
            ),
            SafetyPrecheckBanner(
              command: VehicleCommand(signal: stations.first.fanSpeed, value: 100, source: infotainmentCommandSource),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClimateToggle extends ConsumerWidget {
  const _ClimateToggle({required this.signal, required this.icon, required this.label});

  final VssSignal<bool> signal;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOn = ref.watchSignal(signal) ?? false;

    return VehicleFeatureGuard(
      signal: signal,
      child: FilterChip(
        avatar: Icon(icon, size: 18, color: isOn ? ClimateColors.cool : null),
        label: Text(label),
        selected: isOn,
        showCheckmark: false,
        onSelected: (value) => ref.dispatchCommand(
          context,
          VehicleCommand(signal: signal, value: value, source: infotainmentCommandSource),
        ),
      ),
    );
  }
}
