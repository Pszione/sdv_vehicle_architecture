// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_zonal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Top zone ECU: sunroof.

@ProviderFor(TopZoneController)
final topZoneControllerProvider = TopZoneControllerProvider._();

/// Top zone ECU: sunroof.
final class TopZoneControllerProvider
    extends $NotifierProvider<TopZoneController, void> {
  /// Top zone ECU: sunroof.
  TopZoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topZoneControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topZoneControllerHash();

  @$internal
  @override
  TopZoneController create() => TopZoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$topZoneControllerHash() => r'f56cd31ecda44002b8a6efb9dd967d07dd84fb64';

/// Top zone ECU: sunroof.

abstract class _$TopZoneController extends $Notifier<void> {
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
