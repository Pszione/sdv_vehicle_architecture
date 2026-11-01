import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../broker/vss_broker.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/log_entry.dart';
import 'domain/logger_state.dart';

part 'vehicle_logger.g.dart';

/// In-memory audit log (ring buffer) of commands, rejections and confirmed
/// actuator changes.
///
/// Sensor telemetry (speed, 30 Hz ADAS...) is not recorded, as it would flood the buffer.
@Riverpod(keepAlive: true)
class VehicleLogger extends _$VehicleLogger {
  /// Paths just forced by a simulator: their next broker change is already logged as FORCED.
  final _forcedPaths = <String>{};

  @override
  LoggerState build() {
    ref.listen<Map<String, Object?>>(vssBrokerProvider, (previous, next) {
      if (previous == null) return;
      next.forEach((path, value) {
        if (previous[path] == value || !(vssCatalog[path]?.isActuator ?? false)) return;
        if (_forcedPaths.remove(path)) return;
        _addEntry(LogEntry(type: LogType.signalChange, vssPath: path, payload: value, source: 'ZONAL_TELEMETRY'));
      });
    });
    return LoggerState();
  }

  void logCommand(VehicleCommand<Object> command) => _addEntry(
    LogEntry(type: LogType.command, vssPath: command.signal.path, payload: command.value, source: command.source),
  );

  void logSafetyRejection(VehicleCommand<Object> command, CommandResult result) => _addEntry(
    LogEntry(
      type: LogType.safetyRejection,
      vssPath: command.signal.path,
      payload: command.value,
      source: command.source,
      detailMessage: result.message,
    ),
  );

  /// Records an actuator state written directly by a simulator, bypassing the dispatcher and its rules.
  void logForced(VssSignal<Object> signal, Object value, {required String source}) {
    _forcedPaths.add(signal.path);
    _addEntry(
      LogEntry(
        type: LogType.forced,
        vssPath: signal.path,
        payload: value,
        source: source,
        detailMessage: 'Forced state: safety rules bypassed.',
      ),
    );
  }

  void clearLogs() => state = state.copyWith(entries: []);

  /// Exports the entries as JSON, for local storage or OTA upload.
  List<Map<String, dynamic>> exportJson() => state.entries.map((e) => e.toJson()).toList();

  /// Ring buffer: drops the oldest entry when the capacity is reached.
  void _addEntry(LogEntry entry) {
    final entries = [...state.entries, entry];
    if (entries.length > state.maxCapacity) entries.removeAt(0);
    state = state.copyWith(entries: entries);
  }
}
