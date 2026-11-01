enum LogType { command, signalChange, safetyRejection }

class LogEntry {
  final String id;
  final DateTime timestamp;
  final LogType type;
  final String vssPath;
  final dynamic payload;
  final String source;
  final String? targetZone;
  final String? detailMessage;

  LogEntry({
    required this.type,
    required this.vssPath,
    required this.payload,
    required this.source,
    this.targetZone,
    this.detailMessage,
  })  : id = DateTime.now().microsecondsSinceEpoch.toString(),
        timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
    'vss_path': vssPath,
    'payload': payload,
    'source': source,
    if (targetZone != null) 'target_zone': targetZone,
    if (detailMessage != null) 'detail_message': detailMessage,
  };

  @override
  String toString() {
    final timeStr = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}.${timestamp.millisecond.toString().padLeft(3, '0')}';
    return '[$timeStr] [${type.name.toUpperCase()}] [$source] $vssPath = $payload ${detailMessage != null ? '($detailMessage)' : ''}';
  }
}