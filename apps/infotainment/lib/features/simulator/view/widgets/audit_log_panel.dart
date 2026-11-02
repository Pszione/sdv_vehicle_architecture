import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Live view of the `VehicleLogger`: commands, safety rejections, confirmed
/// actuator changes and forced states, newest first.
class AuditLogPanel extends ConsumerWidget {
  const AuditLogPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(vehicleLoggerProvider.select((state) => state.entries));
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.receipt_long, color: theme.colorScheme.primary),
            title: Text('Audit log', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text('${entries.length} entries'),
            trailing: IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: entries.isEmpty ? null : () => ref.read(vehicleLoggerProvider.notifier).clearLogs(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('Tap a control to see commands and rules here.'))
                : ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    // Newest first.
                    itemBuilder: (context, index) => _LogEntryTile(entry: entries[entries.length - 1 - index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  const _LogEntryTile({required this.entry});

  final LogEntry entry;

  static const _styles = {
    LogType.command: ('COMMAND', Colors.lightBlueAccent),
    LogType.safetyRejection: ('REJECTED', Colors.deepOrangeAccent),
    LogType.signalChange: ('CONFIRMED', Colors.greenAccent),
    LogType.forced: ('FORCED', Colors.redAccent),
    LogType.manual: ('MANUAL', Colors.amberAccent),
  };

  @override
  Widget build(BuildContext context) {
    final (label, color) = _styles[entry.type]!;
    final time = entry.timestamp;
    final clock = [time.hour, time.minute, time.second].map((v) => v.toString().padLeft(2, '0')).join(':');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(clock, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.source,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${entry.vssPath.replaceFirst('Vehicle.', '')} = ${entry.payload}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
          if (entry.detailMessage case final detail?) Text(detail, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
