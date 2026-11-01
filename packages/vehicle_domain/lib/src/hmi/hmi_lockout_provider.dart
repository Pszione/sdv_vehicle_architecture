import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../broker/providers/vss_value_provider.dart';
import '../vss/vss.dart';

part 'hmi_lockout_provider.g.dart';

/// HMI features restricted while driving (driver-distraction guidelines, e.g. NHTSA).
enum HmiFeature {
  videoPlayback('Video playback'),
  keyboardInput('Keyboard input');

  const HmiFeature(this.label);

  final String label;
}

/// Speed above which [HmiFeature]s are locked.
const hmiLockoutSpeedKmh = 8.0;

/// Reason why [feature] is locked right now, or `null` if it is available.
/// Only rebuilds when the "moving" state flips, not on every speed sample.
@riverpod
String? hmiLockoutReason(Ref ref, HmiFeature feature) {
  final isMoving = ref.watch(
    vssValueProvider(Vss.Vehicle.Speed).select((speed) => ((speed as double?) ?? 0) > hmiLockoutSpeedKmh),
  );
  return isMoving ? '${feature.label} is unavailable while driving (above ${hmiLockoutSpeedKmh.toInt()} km/h).' : null;
}
