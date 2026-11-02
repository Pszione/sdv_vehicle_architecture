import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// Inside and outside temperatures (the inside one comes from the central ECU's cabin model).
class ClimateStatusBar extends ConsumerWidget {
  const ClimateStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inside = ref.watchSignal(Vss.Vehicle.Cabin.HVAC.AmbientAirTemperature);
    final outside = ref.watchSignal(Vss.Vehicle.Exterior.AirTemperature);
    final style = Theme.of(context).textTheme.titleMedium;

    String format(double? value) => value == null ? '--' : '${value.toStringAsFixed(1)}°';

    Widget reading(IconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.white54),
        const SizedBox(width: 6),
        Text(text, style: style),
      ],
    );

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 32,
      runSpacing: 4,
      children: [
        reading(Icons.home_outlined, 'Inside ${format(inside)}'),
        reading(Icons.landscape_outlined, 'Outside ${format(outside)}'),
      ],
    );
  }
}
