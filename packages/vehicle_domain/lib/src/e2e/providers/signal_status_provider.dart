import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../profile/providers/active_vehicle_profile.dart';
import '../../vss/vss_signal.dart';
import '../signal_status.dart';

part 'signal_status_provider.g.dart';

/// Status of every supervised signal, by VSS path. Empty until the `E2eReceiver` starts
/// supervising, so code that never receives protected frames (unit tests) sees every signal
/// as valid. Reset on a profile switch.
@Riverpod(keepAlive: true)
class SignalStatusRegistry extends _$SignalStatusRegistry {
  @override
  Map<String, SignalStatus> build() {
    ref.watch(activeVehicleProfileProvider);
    return const {};
  }

  void update(Map<String, SignalStatus> changes) => state = {...state, ...changes};
}

/// Status of a single signal. Only notifies when *this* status changes.
@riverpod
SignalStatus signalStatus(Ref ref, VssSignal<Object> signal) =>
    ref.watch(signalStatusRegistryProvider.select((statuses) => statuses[signal.path] ?? SignalStatus.valid));
