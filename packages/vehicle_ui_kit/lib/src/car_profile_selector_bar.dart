import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarProfileSelectorBar extends ConsumerWidget {
  const CarProfileSelectorBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(activeVehicleProfileProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blueGrey.shade900,
      child: Row(
        children: [
          const Icon(Icons.time_to_leave, color: Colors.white70),
          const SizedBox(width: 12),
          const Text(
            'Perfil do Veículo:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          
          // Seletor em SegmentedButton para troca instantânea
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'entry_level',
                label: Text('Versão Básica'),
                icon: Icon(Icons.car_repair),
              ),
              ButtonSegment(
                value: 'top_level',
                label: Text('Versão Premium'),
                icon: Icon(Icons.star),
              ),
            ],
            selected: {activeProfile.id},
            onSelectionChanged: (newSelection) {
              final selectedId = newSelection.first;
              if (selectedId == 'entry_level') {
                ref.read(activeVehicleProfileProvider.notifier).setProfile(
                      ActiveVehicleProfile.basicProfile,
                    );
              } else {
                ref.read(activeVehicleProfileProvider.notifier).setProfile(
                      ActiveVehicleProfile.premiumProfile,
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}