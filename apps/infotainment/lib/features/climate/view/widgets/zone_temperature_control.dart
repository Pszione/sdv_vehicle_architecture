import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';
import 'climate_colors.dart';

/// Temperature of one climate zone with large +/- controls (0.5 °C steps).
/// A zone can drive several VSS stations (the rear zone drives both rear stations).
class ZoneTemperatureControl extends ConsumerWidget {
  const ZoneTemperatureControl({super.key, required this.label, required this.stations, this.axis = Axis.vertical});

  static const step = 0.5;

  final String label;
  final List<HvacStationSignals> stations;
  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signal = stations.first.temperature;
    final meta = ref.watch(activeVehicleProfileProvider.select((profile) => profile.metaOf(signal)));
    final temperature = ref.watchSignal(signal) ?? 21.0;
    final theme = Theme.of(context);

    void change(double delta) {
      final next = (temperature + delta).clamp(meta?.min?.toDouble() ?? 16, meta?.max?.toDouble() ?? 30);
      for (final station in stations) {
        ref.dispatchCommand(
          context,
          VehicleCommand(signal: station.temperature, value: next, source: infotainmentCommandSource),
        );
      }
    }

    final value = Text(
      '${temperature.toStringAsFixed(1)}°',
      style: (axis == Axis.vertical ? theme.textTheme.displayMedium : theme.textTheme.headlineMedium)?.copyWith(
        color: ClimateColors.forTemperature(temperature),
        fontWeight: FontWeight.w300,
      ),
    );
    final caption = Text(label.toUpperCase(), style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 2));
    final up = IconButton.filledTonal(
      tooltip: '$label warmer',
      iconSize: axis == Axis.vertical ? 40 : 28,
      icon: Icon(axis == Axis.vertical ? Icons.keyboard_arrow_up : Icons.add),
      onPressed: () => change(step),
    );
    final down = IconButton.filledTonal(
      tooltip: '$label cooler',
      iconSize: axis == Axis.vertical ? 40 : 28,
      icon: Icon(axis == Axis.vertical ? Icons.keyboard_arrow_down : Icons.remove),
      onPressed: () => change(-step),
    );

    return VehicleFeatureGuard(
      signal: signal,
      child: axis == Axis.vertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [caption, const SizedBox(height: 16), up, value, down],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                caption,
                const SizedBox(width: 16),
                down,
                const SizedBox(width: 12),
                value,
                const SizedBox(width: 12),
                up,
              ],
            ),
    );
  }
}
