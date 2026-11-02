import 'dart:convert';
import 'dart:typed_data';

/// One protected frame on the bus, after AUTOSAR E2E Profile 1/2: the payload travels with
/// an alive counter and a CRC computed over the Data ID, the counter and the payload.
/// The Data ID itself is not sent: both ends know it, so a frame from the wrong sender
/// (masquerade) or misrouted by a gateway fails the CRC.
final class E2eFrame {
  const E2eFrame({required this.counter, required this.crc, required this.payload});

  /// 4-bit alive counter (0..15), incremented on every send.
  final int counter;
  final int crc;
  final Object payload;
}

/// CRC-8 SAE J1850 (polynomial 0x1D, init and final XOR 0xFF), the CRC of E2E Profile 1.
abstract final class E2eCrc8 {
  static int compute(int dataId, int counter, Object payload) {
    final bytes = [dataId & 0xFF, (dataId >> 8) & 0xFF, counter & 0x0F, ..._payloadBytes(payload)];
    var crc = 0xFF;
    for (final byte in bytes) {
      crc ^= byte;
      for (var bit = 0; bit < 8; bit++) {
        crc = (crc & 0x80) != 0 ? ((crc << 1) ^ 0x1D) & 0xFF : (crc << 1) & 0xFF;
      }
    }
    return crc ^ 0xFF;
  }

  static List<int> _payloadBytes(Object payload) => switch (payload) {
    final double v => (ByteData(8)..setFloat64(0, v)).buffer.asUint8List(),
    final int v => (ByteData(8)..setInt64(0, v)).buffer.asUint8List(),
    final bool v => [if (v) 1 else 0],
    final String v => utf8.encode(v),
    _ => utf8.encode('$payload'),
  };
}

/// Sender side: adds the counter and the CRC.
final class E2eProtector {
  E2eProtector(this.dataId);

  static const counterModulo = 16;

  final int dataId;
  int _counter = 0;

  E2eFrame protect(Object payload) {
    final frame = E2eFrame(counter: _counter, crc: E2eCrc8.compute(dataId, _counter, payload), payload: payload);
    _counter = (_counter + 1) % counterModulo;
    return frame;
  }
}

/// Result of checking one frame (AUTOSAR `E2E_PXXCheckStatusType`).
enum E2eCheckStatus {
  ok,

  /// In sequence, but a few frames were lost (counter jump ≤ [E2eChecker.maxDeltaCounter]).
  okSomeLost,

  /// Same counter as the last frame: the sender is frozen, resending a stale buffer.
  repeated,

  /// Counter jumped too far: frames lost or re-ordered.
  wrongSequence,

  /// CRC mismatch: corrupted frame, or wrong sender (Data ID).
  error;

  bool get isOk => this == ok || this == okSomeLost;
}

/// Receiver side: validates the CRC and the counter progression of one signal.
final class E2eChecker {
  E2eChecker(this.dataId);

  static const maxDeltaCounter = 2;

  final int dataId;
  int? _lastCounter;

  E2eCheckStatus check(E2eFrame frame) {
    if (E2eCrc8.compute(dataId, frame.counter, frame.payload) != frame.crc) return E2eCheckStatus.error;

    final last = _lastCounter;
    _lastCounter = frame.counter;
    if (last == null) return E2eCheckStatus.ok;

    final delta = (frame.counter - last) % E2eProtector.counterModulo;
    return switch (delta) {
      0 => E2eCheckStatus.repeated,
      1 => E2eCheckStatus.ok,
      <= maxDeltaCounter => E2eCheckStatus.okSomeLost,
      _ => E2eCheckStatus.wrongSequence,
    };
  }

  /// Forget the sequence, e.g. when the sender went to sleep.
  void reset() => _lastCounter = null;
}

/// AUTOSAR E2E state machine (`E2E_SM`): turns per-frame results into a stable status,
/// so a single bit flip does not make the signal flicker.
///
/// Keeps the last [windowSize] results. NODATA/INIT go VALID after [minOkInit] good frames;
/// VALID goes INVALID above [maxErrorValid] errors in the window; INVALID recovers once the
/// window holds at least [minOkInvalid] good frames and no error.
final class E2eStateMachine {
  static const windowSize = 3;
  static const minOkInit = 1;
  static const maxErrorValid = 1;
  static const minOkInvalid = 2;

  final _window = <bool>[];
  E2eSmState _state = E2eSmState.noData;

  E2eSmState get state => _state;

  E2eSmState update(E2eCheckStatus status) {
    _window.add(status.isOk);
    if (_window.length > windowSize) _window.removeAt(0);
    final okCount = _window.where((ok) => ok).length;
    final errorCount = _window.length - okCount;

    _state = switch (_state) {
      E2eSmState.noData || E2eSmState.init when okCount >= minOkInit && errorCount == 0 => E2eSmState.valid,
      E2eSmState.noData || E2eSmState.init when errorCount > maxErrorValid => E2eSmState.invalid,
      E2eSmState.noData => E2eSmState.init,
      E2eSmState.valid when errorCount > maxErrorValid => E2eSmState.invalid,
      E2eSmState.invalid when okCount >= minOkInvalid && errorCount == 0 => E2eSmState.valid,
      final unchanged => unchanged,
    };
    return _state;
  }

  void reset() {
    _window.clear();
    _state = E2eSmState.noData;
  }
}

enum E2eSmState { noData, init, valid, invalid }
