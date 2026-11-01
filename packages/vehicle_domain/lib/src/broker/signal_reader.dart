import '../vss/vss_signal.dart';

/// Synchronous, typed signal reads without Riverpod.
/// This is what `SafetyRule`s receive, keeping them pure and easy to test.
abstract interface class SignalReader {
  /// Latest value of the signal, or `null` if the profile lacks it or nothing was reported yet.
  T? read<T extends Object>(VssSignal<T> signal);
}

/// [SignalReader] over a snapshot of the broker state.
final class SnapshotSignalReader implements SignalReader {
  const SnapshotSignalReader(this._values);

  final Map<String, Object?> _values;

  @override
  T? read<T extends Object>(VssSignal<T> signal) => _values[signal.path] as T?;
}
