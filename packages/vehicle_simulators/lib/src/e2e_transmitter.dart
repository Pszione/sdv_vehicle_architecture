import 'package:vehicle_domain/vehicle_domain.dart';

/// Faults that can be injected between a sensor ECU and the central gateway.
enum E2eFault {
  none('None'),

  /// The sender's task hangs but its bus driver keeps resending the last frame:
  /// same counter, stale value. Caught as REPEATED.
  frozenSender('Frozen sender'),

  /// A bit flips on the bus. Caught by the CRC.
  bitFlip('Bit flip'),

  /// Two frames out of three are lost. Caught as WRONGSEQUENCE (counter jump).
  frameLoss('Frame loss'),

  /// The sender stops transmitting. Caught by deadline monitoring (STALE).
  senderDead('Sender dead'),

  /// Another ECU sends on this signal's slot (wrong Data ID). Caught by the CRC.
  masquerade('Wrong sender');

  const E2eFault(this.label);

  final String label;
}

/// Sensor-ECU side of the E2E-protected signals: protects each value (counter + CRC), sends
/// it immediately when it changes and again on every cycle, through the injected fault.
final class E2eTransmitter {
  E2eTransmitter({required this.deliver});

  /// The bus to the gateway, i.e. the `E2eReceiver`.
  final SignalWriteResult Function(VssSignal<Object> signal, E2eFrame frame) deliver;

  final _channels = <VssSignal<Object>, _TxChannel>{};

  E2eFault faultOf(VssSignal<Object> signal) => _channels[signal]?.fault ?? E2eFault.none;

  void injectFault(VssSignal<Object> signal, E2eFault fault) => _channelOf(signal).fault = fault;

  /// Sets the value the sensor measures; it is sent now unless [isAsleep].
  SignalWriteResult send(VssSignal<Object> signal, Object value, {required bool isAsleep}) {
    final channel = _channelOf(signal)..latest = value;
    return isAsleep ? SignalWriteResult.unchanged : _transmit(channel);
  }

  /// Seeds the value without sending, e.g. the sensor's reading at boot.
  void seed(VssSignal<Object> signal, Object value) => _channelOf(signal).latest ??= value;

  /// Cyclic transmission of every seeded signal.
  void sendCycle() {
    for (final channel in _channels.values) {
      if (channel.latest != null) _transmit(channel);
    }
  }

  _TxChannel _channelOf(VssSignal<Object> signal) => _channels.putIfAbsent(signal, () {
    final dataId = E2eProtectedSignals.dataIds[signal]!;
    return _TxChannel(signal, E2eProtector(dataId), E2eProtector(dataId ^ 0x400));
  });

  SignalWriteResult _transmit(_TxChannel channel) {
    final value = channel.latest!;
    switch (channel.fault) {
      case E2eFault.none:
        return deliver(channel.signal, channel.lastFrame = channel.protector.protect(value));
      case E2eFault.frozenSender:
        return deliver(channel.signal, channel.lastFrame ??= channel.protector.protect(value));
      case E2eFault.bitFlip:
        final frame = channel.protector.protect(value);
        return deliver(channel.signal, E2eFrame(counter: frame.counter, crc: frame.crc ^ 0x5A, payload: frame.payload));
      case E2eFault.frameLoss:
        final frame = channel.protector.protect(value);
        return ++channel.framesSinceLoss % 3 == 0 ? deliver(channel.signal, frame) : SignalWriteResult.unchanged;
      case E2eFault.senderDead:
        return SignalWriteResult.unchanged;
      case E2eFault.masquerade:
        return deliver(channel.signal, channel.impostor.protect(value));
    }
  }
}

final class _TxChannel {
  _TxChannel(this.signal, this.protector, this.impostor);

  final VssSignal<Object> signal;
  final E2eProtector protector;

  /// Protector with another Data ID, for the masquerade fault.
  final E2eProtector impostor;

  E2eFault fault = E2eFault.none;
  Object? latest;
  E2eFrame? lastFrame;
  int framesSinceLoss = 0;
}
