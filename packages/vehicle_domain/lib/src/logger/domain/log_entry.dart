enum LogType {
  command,
  signalChange,
  safetyRejection,

  /// Actuator state written by a simulator, bypassing the safety rules.
  forced,

  /// Actuator moved by hand (door handle, manual tailgate): physical, so no command or rule involved.
  manual,
}

class LogEntry {
  final String id;
  final DateTime timestamp;
  final LogType type;
  final String vssPath;
  final Object? payload;
  final String source;
  final String? detailMessage;

  LogEntry({required this.type, required this.vssPath, required this.payload, required this.source, this.detailMessage})
    : id = DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
    'vss_path': vssPath,
    'payload': payload,
    'source': source,
    if (detailMessage != null) 'detail_message': detailMessage,
  };

  @override
  String toString() {
    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}.${timestamp.millisecond.toString().padLeft(3, '0')}';
    return '[$timeStr] [${type.name.toUpperCase()}] [$source] $vssPath = $payload ${detailMessage != null ? '($detailMessage)' : ''}';
  }
}
