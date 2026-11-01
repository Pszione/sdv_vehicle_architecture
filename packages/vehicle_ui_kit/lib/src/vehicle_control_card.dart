import 'package:flutter/material.dart';

/// Common shell for vehicle control cards: icon, title, optional status and content.
class VehicleControlCard extends StatelessWidget {
  const VehicleControlCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.status,
    this.statusColor,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final String? status;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                if (status != null)
                  Text(
                    status!,
                    style: theme.textTheme.labelLarge?.copyWith(color: statusColor ?? theme.colorScheme.secondary),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
