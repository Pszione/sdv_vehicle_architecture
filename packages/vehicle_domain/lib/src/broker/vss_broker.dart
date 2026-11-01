import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../profile/providers/active_vehicle_profile.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';

part 'vss_broker.g.dart';

enum SignalWriteResult { accepted, unchanged, notSupported, outOfRange }

/// Confirmed vehicle state: the latest value of every signal in the active
/// profile, keyed by VSS path.
///
/// Only zonal ECUs and simulators publish here. The UI never writes: it sends a
/// `VehicleCommand` to the `CommandDispatcher`.
/// To read a signal in the UI use `vssValueProvider`, which is granular.
@Riverpod(keepAlive: true)
class VssBroker extends _$VssBroker {
  @override
  Map<String, Object?> build() {
    final profile = ref.watch(activeVehicleProfileProvider);
    return {for (final path in profile.supportedPaths) path: vssCatalog[path]!.defaultValue};
  }

  /// Publishes confirmed telemetry. Values outside the spec are dropped and
  /// reported; repeated values notify nobody.
  SignalWriteResult publish<T extends Object>(VssSignal<T> signal, T value) {
    final meta = ref.read(activeVehicleProfileProvider).metaOf(signal);
    if (meta == null) return SignalWriteResult.notSupported;
    if (!meta.accepts(value)) {
      developer.log('Dropped out-of-spec telemetry: $signal = $value', name: 'VssBroker');
      return SignalWriteResult.outOfRange;
    }
    if (state[signal.path] == value) return SignalWriteResult.unchanged;

    state = {...state, signal.path: value};
    return SignalWriteResult.accepted;
  }
}
