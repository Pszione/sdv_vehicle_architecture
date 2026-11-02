import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../../../../core/cluster_colors.dart';

/// The top driver messages, highest priority first. Warnings can be dismissed.
class MessageCenterPanel extends ConsumerWidget {
  const MessageCenterPanel({super.key});

  static const _maxVisible = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(driverMessageCenterProvider).messages.take(_maxVisible);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final message in messages) _MessageCard(message: message)],
    );
  }
}

class _MessageCard extends ConsumerWidget {
  const _MessageCard({required this.message});

  final DriverMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ClusterColors.severity(message.severity);
    final icon = switch (message.severity) {
      DriverMessageSeverity.warning => Icons.warning_amber_rounded,
      DriverMessageSeverity.fault => Icons.error_outline,
      DriverMessageSeverity.info => Icons.info_outline,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      decoration: BoxDecoration(
        color: ClusterColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message.text, style: const TextStyle(fontSize: 14))),
          if (message.severity == DriverMessageSeverity.warning)
            IconButton(
              tooltip: 'Dismiss',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close, size: 18, color: ClusterColors.textSecondary),
              onPressed: () => ref.read(driverMessageCenterProvider.notifier).acknowledge(message.id),
            ),
        ],
      ),
    );
  }
}
