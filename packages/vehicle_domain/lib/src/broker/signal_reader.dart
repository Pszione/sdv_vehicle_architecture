import '../vss/vss_signal.dart';

/// Leitura síncrona e tipada de sinais, sem depender do Riverpod.
/// É o que as `SafetyRule` recebem, o que as mantém puras e testáveis.
abstract interface class SignalReader {
  /// Último valor do sinal, ou `null` se o sinal não existe no perfil ou ainda não foi reportado.
  T? read<T extends Object>(VssSignal<T> signal);
}

/// [SignalReader] sobre um snapshot do estado do broker.
final class SnapshotSignalReader implements SignalReader {
  const SnapshotSignalReader(this._values);

  final Map<String, Object?> _values;

  @override
  T? read<T extends Object>(VssSignal<T> signal) => _values[signal.path] as T?;
}
