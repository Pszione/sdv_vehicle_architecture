import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../broker/vss_broker.dart';
import '../../logger/vehicle_logger.dart';
import '../../power/power_mode.dart';
import '../../power/providers/power_mode_provider.dart';
import '../../profile/providers/active_vehicle_profile.dart';
import '../../vss/vss_signal.dart';
import '../e2e_protected_signals.dart';
import '../e2e_protection.dart';
import '../signal_status.dart';
import 'signal_status_provider.dart';

part 'e2e_receiver.g.dart';

/// Receiving end of the E2E-protected signals, conceptually running in the central gateway:
/// checks every frame (CRC, alive counter), runs the E2E state machine, supervises deadlines,
/// and only then publishes the value to the `VssBroker`.
///
/// It lives in the domain so any producer (the simulators today, a vehicle bus bridge later)
/// can feed it. Supervision starts with the first frame; deadline monitoring (STALE) runs
/// once the app calls [startDeadlineMonitoring] at boot, so tests that only check frames
/// leave no periodic timer behind.
@Riverpod(keepAlive: true)
class E2eReceiver extends _$E2eReceiver {
  static const _monitorTick = Duration(milliseconds: 50);

  final _channels = <String, _Channel>{};
  var _isSupervising = false;
  var _isMonitoringRequested = false;

  @override
  void build() {
    final profile = ref.watch(activeVehicleProfileProvider);
    _isSupervising = false;
    _channels
      ..clear()
      ..addAll({
        for (final MapEntry(key: signal, value: dataId) in E2eProtectedSignals.dataIds.entries)
          if (profile.metaOf(signal) != null) signal.path: _Channel(signal, E2eChecker(dataId)),
      });

    // Sleeping ECUs stop sending on purpose: their data is not available, not stale.
    ref.listen(powerModeProvider, (_, mode) {
      if (mode == PowerMode.sleep) _suspendSupervision();
    });
    if (_isMonitoringRequested) _startMonitorTimer();
  }

  /// Starts deadline monitoring: a protected signal without frames for the timeout becomes STALE.
  /// Survives profile switches.
  void startDeadlineMonitoring() {
    if (_isMonitoringRequested) return;
    _isMonitoringRequested = true;
    _startMonitorTimer();
  }

  void _startMonitorTimer() {
    final monitor = Timer.periodic(_monitorTick, (_) => _monitorDeadlines());
    ref.onDispose(monitor.cancel);
  }

  /// Checks [frame] for [signal] and publishes its payload when the signal is valid.
  SignalWriteResult receive(VssSignal<Object> signal, E2eFrame frame) {
    final channel = _channels[signal.path];
    if (channel == null) return SignalWriteResult.notSupported;
    _startSupervision();

    channel.ticksSinceFrame = 0;
    final check = channel.checker.check(frame);
    final state = channel.stateMachine.update(check);
    _setStatus(channel, switch (state) {
      E2eSmState.valid => SignalStatus.valid,
      E2eSmState.invalid => SignalStatus.invalid,
      E2eSmState.noData || E2eSmState.init => SignalStatus.notAvailable,
    }, reason: 'E2E check: ${check.name}');

    // A tolerated error keeps the signal valid, but its payload is never used.
    if (state != E2eSmState.valid || !check.isOk) return SignalWriteResult.unchanged;
    return ref.read(vssBrokerProvider.notifier).publish(signal, frame.payload);
  }

  void _startSupervision() {
    if (_isSupervising) return;
    _isSupervising = true;
    ref.read(signalStatusRegistryProvider.notifier).update({
      for (final channel in _channels.values) channel.signal.path: SignalStatus.notAvailable,
    });
  }

  void _monitorDeadlines() {
    if (!_isSupervising || ref.read(powerModeProvider) == PowerMode.sleep) return;
    final timeoutTicks = E2eProtectedSignals.timeout.inMilliseconds ~/ _monitorTick.inMilliseconds;
    for (final channel in _channels.values) {
      channel.ticksSinceFrame++;
      if (channel.ticksSinceFrame < timeoutTicks || channel.status == SignalStatus.notAvailable) continue;
      if (channel.status == SignalStatus.stale) continue;
      channel.reset();
      _setStatus(channel, SignalStatus.stale, reason: 'No frame for ${E2eProtectedSignals.timeout.inMilliseconds} ms');
    }
  }

  void _suspendSupervision() {
    final changes = <String, SignalStatus>{};
    for (final channel in _channels.values) {
      channel
        ..reset()
        ..status = SignalStatus.notAvailable;
      changes[channel.signal.path] = SignalStatus.notAvailable;
    }
    if (_isSupervising) ref.read(signalStatusRegistryProvider.notifier).update(changes);
  }

  void _setStatus(_Channel channel, SignalStatus status, {required String reason}) {
    final previous = channel.status;
    if (previous == status) return;
    channel.status = status;
    ref.read(signalStatusRegistryProvider.notifier).update({channel.signal.path: status});

    final logger = ref.read(vehicleLoggerProvider.notifier);
    if (status == SignalStatus.stale || status == SignalStatus.invalid) {
      logger.logSignalFault(channel.signal, status, reason);
    } else if (status == SignalStatus.valid && (previous == SignalStatus.stale || previous == SignalStatus.invalid)) {
      logger.logSignalFault(channel.signal, status, 'Signal recovered');
    }
  }
}

final class _Channel {
  _Channel(this.signal, this.checker);

  final VssSignal<Object> signal;
  final E2eChecker checker;
  final stateMachine = E2eStateMachine();
  SignalStatus status = SignalStatus.notAvailable;
  int ticksSinceFrame = 0;

  void reset() {
    checker.reset();
    stateMachine.reset();
    ticksSinceFrame = 0;
  }
}
