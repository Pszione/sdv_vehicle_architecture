// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zonal_system_bootstrap.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Liga todas as ECUs zonais. O app lê este provider no boot, antes do primeiro
/// comando: sem isso, os controladores não existiriam para escutar o barramento.

@ProviderFor(zonalSystem)
final zonalSystemProvider = ZonalSystemProvider._();

/// Liga todas as ECUs zonais. O app lê este provider no boot, antes do primeiro
/// comando: sem isso, os controladores não existiriam para escutar o barramento.

final class ZonalSystemProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Liga todas as ECUs zonais. O app lê este provider no boot, antes do primeiro
  /// comando: sem isso, os controladores não existiriam para escutar o barramento.
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
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return zonalSystem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$zonalSystemHash() => r'51816823350d56c5d70ffa54fb9c84f0a5c34362';
