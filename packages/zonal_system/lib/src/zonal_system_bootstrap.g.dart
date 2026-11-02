// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zonal_system_bootstrap.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Starts one ECU per zone, the vehicle mode manager and the network management.
/// The app reads this provider at boot, before the first command: otherwise no
/// controller would exist to listen to the bus.

@ProviderFor(zonalSystem)
final zonalSystemProvider = ZonalSystemProvider._();

/// Starts one ECU per zone, the vehicle mode manager and the network management.
/// The app reads this provider at boot, before the first command: otherwise no
/// controller would exist to listen to the bus.

final class ZonalSystemProvider extends $FunctionalProvider<void, void, void> with $Provider<void> {
  /// Starts one ECU per zone, the vehicle mode manager and the network management.
  /// The app reads this provider at boot, before the first command: otherwise no
  /// controller would exist to listen to the bus.
  ZonalSystemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zonalSystemProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zonalSystemHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return zonalSystem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$zonalSystemHash() => r'ea4a3a74fbed3ef1f245ffa389e6ad9006b9f408';
