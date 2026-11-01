import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// Slider that drives a simulated numeric sensor (double or int). Hidden when the active profile lacks it.
class SimulatedSensorSlider extends ConsumerWidget {
  const SimulatedSensorSlider({
    super.key,
    required this.signal,
    required this.label,
    required this.min,
    required this.max,
    required this.unit,
    this.warnAbove,
  });

  final VssSignal<num> signal;
  final String label;
  final double min;
  final double max;
  final String unit;

  /// Absolute value above which the reading is highlighted (e.g. a rule threshold).
  final double? warnAbove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watchSignal(signal)?.toDouble() ?? min;
    final isWarning = warnAbove != null && value.abs() > warnAbove!;
    final color = isWarning ? Colors.orangeAccent : Colors.cyanAccent;

    return VehicleFeatureGuard(
      signal: signal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${value.round()} $unit',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            activeColor: color,
            inactiveColor: Colors.white10,
            // Integer sensors (e.g. uint8 brake pedal) must receive an int.
            onChanged: (newValue) => ref
                .read(telemetrySimulatorProvider.notifier)
                .report(signal, signal is VssSignal<int> ? newValue.round() : newValue),
          ),
        ],
      ),
    );
  }
}
