import '../e2e/signal_status.dart';
import '../vss/vss_signal.dart';

/// Synchronous, typed signal reads without Riverpod.
/// This is what `SafetyRule`s receive, keeping them pure and easy to test.
abstract interface class SignalReader {
  /// Latest *trustworthy* value of the signal, or `null` when the profile lacks it, nothing
  /// was reported yet, or the signal is not valid (lost, corrupted, sender asleep).
  /// Every rule must say what it does with `null` (fail-safe).
  T? read<T extends Object>(VssSignal<T> signal);

  /// Health of the signal; always [SignalStatus.valid] for signals that are not supervised.
  SignalStatus statusOf(VssSignal<Object> signal);
}

/// [SignalReader] over a snapshot of the broker state and of the signal statuses.
final class SnapshotSignalReader implements SignalReader {
  const SnapshotSignalReader(this._values, [this._statuses = const {}]);

  final Map<String, Object?> _values;
  final Map<String, SignalStatus> _statuses;

  @override
  T? read<T extends Object>(VssSignal<T> signal) =>
      statusOf(signal) == SignalStatus.valid ? _values[signal.path] as T? : null;

  @override
  SignalStatus statusOf(VssSignal<Object> signal) => _statuses[signal.path] ?? SignalStatus.valid;
}
