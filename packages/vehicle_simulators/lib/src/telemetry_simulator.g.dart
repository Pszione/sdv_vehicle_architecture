// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_simulator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fake sensors: publishes readings to the [VssBroker] as if they came from ECUs.
///
/// This is the only place outside the zonal ECUs allowed to publish telemetry.
/// The broker still validates every value against the spec and the active
/// profile, so a reading the car does not have is ignored ([SignalWriteResult.notSupported]).

@ProviderFor(TelemetrySimulator)
final telemetrySimulatorProvider = TelemetrySimulatorProvider._();

/// Fake sensors: publishes readings to the [VssBroker] as if they came from ECUs.
///
/// This is the only place outside the zonal ECUs allowed to publish telemetry.
/// The broker still validates every value against the spec and the active
/// profile, so a reading the car does not have is ignored ([SignalWriteResult.notSupported]).
final class TelemetrySimulatorProvider
    extends $NotifierProvider<TelemetrySimulator, void> {
  /// Fake sensors: publishes readings to the [VssBroker] as if they came from ECUs.
  ///
  /// This is the only place outside the zonal ECUs allowed to publish telemetry.
  /// The broker still validates every value against the spec and the active
  /// profile, so a reading the car does not have is ignored ([SignalWriteResult.notSupported]).
  TelemetrySimulatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetrySimulatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetrySimulatorHash();

  @$internal
  @override
  TelemetrySimulator create() => TelemetrySimulator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$telemetrySimulatorHash() =>
    r'0f158b2d9fd19c5cf49616af095ff35fea38aad2';

/// Fake sensors: publishes readings to the [VssBroker] as if they came from ECUs.
///
/// This is the only place outside the zonal ECUs allowed to publish telemetry.
/// The broker still validates every value against the spec and the active
/// profile, so a reading the car does not have is ignored ([SignalWriteResult.notSupported]).

abstract class _$TelemetrySimulator extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
