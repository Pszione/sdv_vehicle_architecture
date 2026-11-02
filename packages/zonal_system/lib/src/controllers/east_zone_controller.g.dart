// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'east_zone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// East zone ECU: right-hand body (door locks, seats, window shades).

@ProviderFor(EastZoneController)
final eastZoneControllerProvider = EastZoneControllerProvider._();

/// East zone ECU: right-hand body (door locks, seats, window shades).
final class EastZoneControllerProvider extends $NotifierProvider<EastZoneController, void> {
  /// East zone ECU: right-hand body (door locks, seats, window shades).
  EastZoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eastZoneControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eastZoneControllerHash();

  @$internal
  @override
  EastZoneController create() => EastZoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$eastZoneControllerHash() => r'32406ff0eebf5458ffa16ce24cfa921f14533704';

/// East zone ECU: right-hand body (door locks, seats, window shades).

abstract class _$EastZoneController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
