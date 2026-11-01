import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'domain/log_entry.dart';
import 'domain/logger_state.dart';

part 'vehicle_logger_provider.g.dart';


@riverpod
class VehicleLogger extends _$VehicleLogger {
  @override
  LoggerState build() {
    // 1. Escuta comandos trafegados no Barramento Zonal
    ref.listen<AsyncValue<ZonalCommand>>(zonalCommandBusProvider, (previous, next) {
      next.whenData((command) {
        _addEntry(
          LogEntry(
            type: LogType.command,
            vssPath: command.vssPath,
            payload: command.actionPayload,
            source: 'COMMAND_DISPATCHER',
            targetZone: command.targetZone,
            detailMessage: 'DeviceId: ${command.deviceId}',
          ),
        );
      });
    });

    // 2. Escuta mudanças confirmadas nos sinais VSS
    ref.listen<Map<String, dynamic>>(vssBrokerProvider, (previous, next) {
      if (previous == null) return;

      // Identifica qual sinal mudou comparando o estado anterior com o novo
      next.forEach((path, value) {
        if (previous[path] != value) {
          _addEntry(
            LogEntry(
              type: LogType.signalChange,
              vssPath: path,
              payload: value,
              source: 'ZONAL_TELEMETRY',
            ),
          );
        }
      });
    });

    return LoggerState();
  }

  /// Adiciona uma nova entrada aplicando a política de Ring Buffer
  void _addEntry(LogEntry entry) {
    final updatedList = List<LogEntry>.from(state.entries)..add(entry);

    if (updatedList.length > state.maxCapacity) {
      updatedList.removeAt(0); // Descarta o registro mais antigo
    }

    state = state.copyWith(entries: updatedList);
  }

  /// Permite que o CommandDispatcher registre rejeições de segurança
  void logSafetyRejection({
    required String vssPath,
    required dynamic attemptedPayload,
    required String reason,
    required String source,
  }) {
    _addEntry(
      LogEntry(
        type: LogType.safetyRejection,
        vssPath: vssPath,
        payload: attemptedPayload,
        source: source,
        detailMessage: reason,
      ),
    );
  }

  /// Limpa o histórico em memória
  void clearLogs() {
    state = state.copyWith(entries: []);
  }

  /// Exporta todos os registros no formato JSON formatado para gravação local ou envio OTA
  List<Map<String, dynamic>> exportJson() {
    return state.entries.map((e) => e.toJson()).toList();
  }
}