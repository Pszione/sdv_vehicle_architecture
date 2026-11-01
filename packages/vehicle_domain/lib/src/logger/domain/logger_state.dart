
import 'log_entry.dart';

class LoggerState {
  final List<LogEntry> entries;
  final int maxCapacity;

  LoggerState({
    this.entries = const [],
    this.maxCapacity = 500, // Limite para evitar estouro de memória no In-Memory Buffer
  });

  LoggerState copyWith({List<LogEntry>? entries}) {
    return LoggerState(
      entries: entries ?? this.entries,
      maxCapacity: maxCapacity,
    );
  }
}