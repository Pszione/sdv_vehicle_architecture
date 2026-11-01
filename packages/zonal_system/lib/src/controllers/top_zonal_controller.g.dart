// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_zonal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ECU da zona superior: teto solar.

@ProviderFor(TopZoneController)
final topZoneControllerProvider = TopZoneControllerProvider._();

/// ECU da zona superior: teto solar.
final class TopZoneControllerProvider
    extends $NotifierProvider<TopZoneController, void> {
  /// ECU da zona superior: teto solar.
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

String _$topZoneControllerHash() => r'595165663a40e58c1225006a06cc3cae8aed80ab';

/// ECU da zona superior: teto solar.

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
