// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zonal_system_bootstrap.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Starts one ECU per zone. The app reads this provider at boot, before the
/// first command: otherwise no controller would exist to listen to the bus.

@ProviderFor(zonalSystem)
final zonalSystemProvider = ZonalSystemProvider._();

/// Starts one ECU per zone. The app reads this provider at boot, before the
/// first command: otherwise no controller would exist to listen to the bus.

final class ZonalSystemProvider extends $FunctionalProvider<void, void, void> with $Provider<void> {
  /// Starts one ECU per zone. The app reads this provider at boot, before the
  /// first command: otherwise no controller would exist to listen to the bus.
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

String _$zonalSystemHash() => r'e278fb459dba3e5b8a2d8eff39803ae55671c3ae';
