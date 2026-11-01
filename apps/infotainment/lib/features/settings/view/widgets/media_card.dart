import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// Media features restricted while driving (driver-distraction guidelines).
/// This is an HMI policy, not a vehicle command, so it does not go through the dispatcher.
class MediaCard extends ConsumerWidget {
  const MediaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLock = ref.watch(hmiLockoutReasonProvider(HmiFeature.videoPlayback));
    final keyboardLock = ref.watch(hmiLockoutReasonProvider(HmiFeature.keyboardInput));

    return VehicleControlCard(
      icon: Icons.ondemand_video,
      title: 'Media',
      status: videoLock == null ? null : 'DRIVING',
      statusColor: Colors.orangeAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play video'),
            onPressed: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: videoLock == null ? null : Colors.red.shade900,
                  content: Text(videoLock ?? 'Playing video…'),
                ),
              ),
          ),
          const SizedBox(height: 12),
          TextField(
            readOnly: keyboardLock != null,
            decoration: InputDecoration(
              labelText: 'Search destination',
              prefixIcon: const Icon(Icons.keyboard),
              helperText: keyboardLock,
              helperMaxLines: 2,
              helperStyle: const TextStyle(color: Colors.orangeAccent),
            ),
          ),
        ],
      ),
    );
  }
}
