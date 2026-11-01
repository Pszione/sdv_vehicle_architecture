import '../../broker/signal_reader.dart';
import '../../dispatcher/domain/vehicle_commands.dart';
import '../../vss/vss_signal.dart';

/// Something the car does on its own when its state changes (auto-lock, auto-park...).
///
/// Behaviors never write to the broker: they return commands that go through the
/// `CommandDispatcher`, so every safety rule still applies and the audit log shows them.
abstract interface class VehicleBehavior {
  /// Signals whose change triggers [react].
  Set<VssSignal<Object>> get triggers;

  /// Commands to dispatch given the state [before] and [after] a change of a trigger.
  /// Use [source] on every command so the audit log shows who issued it.
  List<VehicleCommand<Object>> react(SignalReader before, SignalReader after);
}

extension VehicleBehaviorReads on SignalReader {
  /// Whether [signal] crossed above [threshold] between [before] and this state.
  bool crossedAbove(SignalReader before, VssSignal<double> signal, double threshold) =>
      (before.read(signal) ?? 0) <= threshold && (read(signal) ?? 0) > threshold;

  /// Whether [signal] crossed below [threshold] between [before] and this state.
  bool crossedBelow(SignalReader before, VssSignal<double> signal, double threshold) =>
      (before.read(signal) ?? 0) >= threshold && (read(signal) ?? 0) < threshold;

  /// Whether [signal] changed to [value] between [before] and this state.
  bool becameEqual<T extends Object>(SignalReader before, VssSignal<T> signal, T value) =>
      before.read(signal) != value && read(signal) == value;
}
