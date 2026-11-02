import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../broker/providers/vss_value_provider.dart';
import '../../broker/signal_reader.dart';
import '../../broker/vss_broker.dart';
import '../../e2e/providers/signal_status_provider.dart';
import '../../power/power_mode.dart';
import '../../power/providers/power_mode_provider.dart';
import '../telltales.dart';

part 'telltale_provider.g.dart';

/// Bulb check: every telltale lights up for [duration] when the vehicle becomes READY,
/// so the driver can see that none is burnt out (regulatory requirement for red telltales).
@Riverpod(keepAlive: true)
class BulbCheck extends _$BulbCheck {
  static const duration = Duration(seconds: 2);

  Timer? _timer;

  @override
  bool build() {
    ref.listen(powerModeProvider, (previous, next) {
      if (next != PowerMode.ready || previous == PowerMode.ready) return;
      state = true;
      _timer?.cancel();
      _timer = Timer(duration, () {
        if (ref.mounted) state = false;
      });
    });
    ref.onDispose(() => _timer?.cancel());
    return false;
  }
}

/// State of one telltale. Watches only that telltale's inputs (value and E2E status), so
/// at 60 FPS a speed change never re-evaluates the parking brake light.
@riverpod
TelltaleState telltaleState(Ref ref, Telltale telltale) {
  // Telltales are lit with the ignition on, like a real cluster.
  final mode = ref.watch(powerModeProvider);
  if (mode != null && mode != PowerMode.on && mode != PowerMode.ready) return TelltaleState.off;
  if (ref.watch(bulbCheckProvider)) return TelltaleState.on;

  for (final input in TelltaleLogic.inputsOf(telltale)) {
    ref
      ..watch(vssValueProvider(input))
      ..watch(signalStatusProvider(input));
  }
  final signals = SnapshotSignalReader(ref.read(vssBrokerProvider), ref.read(signalStatusRegistryProvider));
  return TelltaleLogic.evaluate(telltale, signals);
}
