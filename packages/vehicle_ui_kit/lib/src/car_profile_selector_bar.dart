import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Switches the vehicle profile live (simulation/demo tool).
class CarProfileSelectorBar extends ConsumerWidget {
  const CarProfileSelectorBar({super.key, required this.profiles});

  final List<VehicleProfile> profiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeVehicleProfileProvider.select((profile) => profile.id));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blueGrey.shade900,
      child: Row(
        children: [
          const Icon(Icons.time_to_leave, color: Colors.white70),
          const SizedBox(width: 12),
          const Text(
            'Vehicle profile:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<String>(
                segments: [
                  for (final profile in profiles) ButtonSegment(value: profile.id, label: Text(profile.trimName)),
                ],
                selected: {activeId},
                onSelectionChanged: (selection) => ref
                    .read(activeVehicleProfileProvider.notifier)
                    .setProfile(profiles.firstWhere((profile) => profile.id == selection.first)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
