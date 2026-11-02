import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';
import 'climate_colors.dart';

/// Seat heating/ventilation (COVESA `HeatingCooling`, -100..100).
/// Tap cycles heating 1-2-3-off; long press cycles ventilation 1-2-3-off (Tesla-style).
class SeatClimateButton extends ConsumerWidget {
  const SeatClimateButton({super.key, required this.seat});

  static const _levels = [33, 66, 100];

  final SeatSignals seat;

  static int _next(int current, {required bool heating}) {
    final sign = heating ? 1 : -1;
    final steps = [0, ..._levels.map((level) => level * sign)];
    final index = steps.indexOf(current);
    return steps[(index + 1) % steps.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watchSignal(seat.heatingCooling) ?? 0;
    final isOccupied = ref.watchSignal(seat.occupancy) == SeatOccupancy.occupied;
    final level = (value.abs() / 33).round();
    final color = value > 0 ? ClimateColors.heat : (value < 0 ? ClimateColors.cool : Colors.white38);

    void send(int next) => ref.dispatchCommand(
      context,
      VehicleCommand(signal: seat.heatingCooling, value: next, source: infotainmentCommandSource),
    );

    return VehicleFeatureGuard(
      signal: seat.heatingCooling,
      child: Tooltip(
        message: '${seat.label} seat: tap to heat, long press to ventilate',
        child: InkResponse(
          radius: 40,
          onTap: () => send(_next(value <= 0 ? 0 : value, heating: true)),
          onLongPress: () => send(_next(value >= 0 ? 0 : value, heating: false)),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: value == 0 ? 0.08 : 0.18),
              border: Border.all(color: color.withValues(alpha: 0.6)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  value > 0 ? Icons.whatshot : (value < 0 ? Icons.air : Icons.event_seat),
                  color: isOccupied && value == 0 ? Colors.white70 : color,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 1; i <= _levels.length; i++)
                      Container(
                        width: 8,
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        color: i <= level ? color : Colors.white12,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Steering wheel heating (COVESA `SteeringWheel.HeatingCooling`): on/off.
class SteeringWheelHeatButton extends ConsumerWidget {
  const SteeringWheelHeatButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signal = Vss.Vehicle.Chassis.SteeringWheel.HeatingCooling;
    final isOn = (ref.watchSignal(signal) ?? 0) > 0;

    return VehicleFeatureGuard(
      signal: signal,
      child: IconButton(
        tooltip: 'Steering wheel heating',
        isSelected: isOn,
        icon: const Icon(Icons.trip_origin),
        selectedIcon: const Icon(Icons.trip_origin, color: ClimateColors.heat),
        onPressed: () => ref.dispatchCommand(
          context,
          VehicleCommand(signal: signal, value: isOn ? 0 : 100, source: infotainmentCommandSource),
        ),
      ),
    );
  }
}
