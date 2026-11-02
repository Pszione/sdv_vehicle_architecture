import 'package:flutter/foundation.dart';

/// A value received at a low rate (e.g. 30 Hz from a camera ECU) and drawn at the display
/// rate: [advance] moves it linearly from the previous sample to the latest one over
/// [samplePeriod], so a 60 FPS painter never jumps from sample to sample.
final class InterpolatedValue {
  InterpolatedValue(double initial, {this.samplePeriod = const Duration(milliseconds: 33)})
    : _from = initial,
      _to = initial,
      _current = initial;

  final Duration samplePeriod;
  double _from;
  double _to;
  double _current;
  Duration _sinceSample = Duration.zero;

  double get value => _current;

  bool get isSettled => _current == _to;

  /// A new sample arrived: interpolate from where the drawing is now.
  set target(double value) {
    _from = _current;
    _to = value;
    _sinceSample = Duration.zero;
  }

  /// Advances by [elapsed] display time. Returns whether the value changed.
  bool advance(Duration elapsed) {
    if (isSettled) return false;
    _sinceSample += elapsed;
    final t = (_sinceSample.inMicroseconds / samplePeriod.inMicroseconds).clamp(0.0, 1.0);
    _current = _from + (_to - _from) * t;
    return true;
  }

  @visibleForTesting
  void jumpTo(double value) => _from = _to = _current = value;
}
