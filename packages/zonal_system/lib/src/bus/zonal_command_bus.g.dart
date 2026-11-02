// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zonal_command_bus.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(zonalCommandBus)
final zonalCommandBusProvider = ZonalCommandBusProvider._();

final class ZonalCommandBusProvider extends $FunctionalProvider<ZonalCommandBus, ZonalCommandBus, ZonalCommandBus>
    with $Provider<ZonalCommandBus> {
  ZonalCommandBusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zonalCommandBusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zonalCommandBusHash();

  @$internal
  @override
  $ProviderElement<ZonalCommandBus> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ZonalCommandBus create(Ref ref) {
    return zonalCommandBus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZonalCommandBus value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ZonalCommandBus>(value));
  }
}

String _$zonalCommandBusHash() => r'd30dc3cc076d980bcbd78bde6af992321618619d';
