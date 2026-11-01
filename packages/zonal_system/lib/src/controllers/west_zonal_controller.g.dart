// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'west_zonal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ECU da zona oeste: travas das portas do lado esquerdo.

@ProviderFor(WestZoneController)
final westZoneControllerProvider = WestZoneControllerProvider._();

/// ECU da zona oeste: travas das portas do lado esquerdo.
final class WestZoneControllerProvider
    extends $NotifierProvider<WestZoneController, void> {
  /// ECU da zona oeste: travas das portas do lado esquerdo.
  WestZoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'westZoneControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$westZoneControllerHash();

  @$internal
  @override
  WestZoneController create() => WestZoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$westZoneControllerHash() =>
    r'd8a8438327e4a4d2257e41b88fd13291d913e1de';

/// ECU da zona oeste: travas das portas do lado esquerdo.

abstract class _$WestZoneController extends $Notifier<void> {
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
