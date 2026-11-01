import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../broker/vss_broker.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import 'domain/log_entry.dart';
import 'domain/logger_state.dart';

part 'vehicle_logger.g.dart';

/// Audit log em memória (ring buffer) de comandos, rejeições e mudanças
/// confirmadas de atuadores.
///
/// Telemetria de sensores (velocidade, ADAS a 30 Hz...) não é registrada,
/// porque inundaria o buffer.
@Riverpod(keepAlive: true)
class VehicleLogger extends _$VehicleLogger {
  @override
  LoggerState build() {
    ref.listen<Map<String, Object?>>(vssBrokerProvider, (previous, next) {
      if (previous == null) return;
      next.forEach((path, value) {
        if (previous[path] == value || !(vssCatalog[path]?.isActuator ?? false)) return;
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

  void clearLogs() => state = state.copyWith(entries: []);

  /// Exporta os registros em JSON, para gravação local ou envio OTA.
  List<Map<String, dynamic>> exportJson() => state.entries.map((e) => e.toJson()).toList();

  /// Ring buffer: descarta o registro mais antigo ao atingir a capacidade.
  void _addEntry(LogEntry entry) {
    final entries = [...state.entries, entry];
    if (entries.length > state.maxCapacity) entries.removeAt(0);
    state = state.copyWith(entries: entries);
  }
}
