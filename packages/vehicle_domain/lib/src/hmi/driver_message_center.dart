import 'package:meta/meta.dart';

/// Severity of a driver message, highest priority first.
enum DriverMessageSeverity { warning, fault, info }

/// A message on the cluster's message center.
@immutable
final class DriverMessage {
  const DriverMessage({required this.id, required this.text, required this.severity, this.displayFor});

  /// Deduplication key: a new message with the same id replaces the old one.
  final String id;
  final String text;
  final DriverMessageSeverity severity;

  /// Removed automatically after this time; `null` stays until acknowledged or cleared.
  final Duration? displayFor;

  @override
  bool operator ==(Object other) =>
      other is DriverMessage && other.id == id && other.text == text && other.severity == severity;

  @override
  int get hashCode => Object.hash(id, text, severity);
}

/// Priority queue of driver messages: warnings first, then faults, then information;
/// newest first within the same severity.
@immutable
final class DriverMessageQueue {
  const DriverMessageQueue([this.messages = const []]);

  final List<DriverMessage> messages;

  DriverMessageQueue post(DriverMessage message) {
    final others = messages.where((m) => m.id != message.id);
    final sorted = [message, ...others]..sort((a, b) => a.severity.index.compareTo(b.severity.index));
    return DriverMessageQueue(List.unmodifiable(sorted));
  }

  DriverMessageQueue remove(String id) =>
      DriverMessageQueue(List.unmodifiable(messages.where((message) => message.id != id)));
}
