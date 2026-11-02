// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'west_zone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// West zone ECU: left-hand body (door locks, seats, window shades).

@ProviderFor(WestZoneController)
final westZoneControllerProvider = WestZoneControllerProvider._();

/// West zone ECU: left-hand body (door locks, seats, window shades).
final class WestZoneControllerProvider extends $NotifierProvider<WestZoneController, void> {
  /// West zone ECU: left-hand body (door locks, seats, window shades).
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
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$westZoneControllerHash() => r'4c3ea6f06641f870336e5379c7940679dca7a6e1';

/// West zone ECU: left-hand body (door locks, seats, window shades).

abstract class _$WestZoneController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
