import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Warns ahead of time that [command] would be rejected right now, with the
/// message of the blocking safety rule. Renders nothing when the command would pass.
///
/// It is a heads-up only: the control stays enabled and the dispatcher has the final word.
class SafetyPrecheckBanner extends ConsumerWidget {
  const SafetyPrecheckBanner({super.key, required this.command});

  final VehicleCommand<Object> command;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evaluation = ref.watch(canDispatchProvider(command));
    if (evaluation.isSuccess) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              evaluation.message ?? 'Action unavailable right now.',
              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
