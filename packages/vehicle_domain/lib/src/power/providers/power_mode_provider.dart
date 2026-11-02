import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../broker/providers/vss_value_provider.dart';
import '../../broker/signal_reader.dart';
import '../../broker/vss_broker.dart';
import '../power_mode.dart';

part 'power_mode_provider.g.dart';

/// Current [PowerMode]. Only re-evaluates when one of its input signals changes.
@Riverpod(keepAlive: true)
PowerMode? powerMode(Ref ref) {
  for (final input in PowerMode.inputs) {
    ref.watch(vssValueProvider(input));
  }
  return PowerMode.from(SnapshotSignalReader(ref.read(vssBrokerProvider)));
}
