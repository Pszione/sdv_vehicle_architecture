// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vss_broker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Confirmed vehicle state: the latest value of every signal in the active
/// profile, keyed by VSS path.
///
/// Only zonal ECUs and simulators publish here. The UI never writes: it sends a
/// `VehicleCommand` to the `CommandDispatcher`.
/// To read a signal in the UI use `vssValueProvider`, which is granular.

@ProviderFor(VssBroker)
final vssBrokerProvider = VssBrokerProvider._();

/// Confirmed vehicle state: the latest value of every signal in the active
/// profile, keyed by VSS path.
///
/// Only zonal ECUs and simulators publish here. The UI never writes: it sends a
/// `VehicleCommand` to the `CommandDispatcher`.
/// To read a signal in the UI use `vssValueProvider`, which is granular.
final class VssBrokerProvider
    extends $NotifierProvider<VssBroker, Map<String, Object?>> {
  /// Confirmed vehicle state: the latest value of every signal in the active
  /// profile, keyed by VSS path.
  ///
  /// Only zonal ECUs and simulators publish here. The UI never writes: it sends a
  /// `VehicleCommand` to the `CommandDispatcher`.
  /// To read a signal in the UI use `vssValueProvider`, which is granular.
  VssBrokerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vssBrokerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vssBrokerHash();

  @$internal
  @override
  VssBroker create() => VssBroker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Object?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Object?>>(value),
    );
  }
}

String _$vssBrokerHash() => r'd5bcf3f613ad7fd3fd742ff515d1871a9ad95c6d';

/// Confirmed vehicle state: the latest value of every signal in the active
/// profile, keyed by VSS path.
///
/// Only zonal ECUs and simulators publish here. The UI never writes: it sends a
/// `VehicleCommand` to the `CommandDispatcher`.
/// To read a signal in the UI use `vssValueProvider`, which is granular.

abstract class _$VssBroker extends $Notifier<Map<String, Object?>> {
  Map<String, Object?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, Object?>, Map<String, Object?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, Object?>, Map<String, Object?>>,
              Map<String, Object?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
