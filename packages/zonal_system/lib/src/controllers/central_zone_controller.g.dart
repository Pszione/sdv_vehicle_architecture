// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'central_zone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Central ECU: roof (sunroof), HVAC/thermal (cabin model + AUTO fan) and the
/// gateway to non-zonal domain ECUs (powertrain, chassis, ADAS), which confirm
/// the commanded value.

@ProviderFor(CentralZoneController)
final centralZoneControllerProvider = CentralZoneControllerProvider._();

/// Central ECU: roof (sunroof), HVAC/thermal (cabin model + AUTO fan) and the
/// gateway to non-zonal domain ECUs (powertrain, chassis, ADAS), which confirm
/// the commanded value.
final class CentralZoneControllerProvider extends $NotifierProvider<CentralZoneController, void> {
  /// Central ECU: roof (sunroof), HVAC/thermal (cabin model + AUTO fan) and the
  /// gateway to non-zonal domain ECUs (powertrain, chassis, ADAS), which confirm
  /// the commanded value.
  CentralZoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'centralZoneControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$centralZoneControllerHash();

  @$internal
  @override
  CentralZoneController create() => CentralZoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$centralZoneControllerHash() => r'337ec4ec4f932a3beb1a0d8480209622e57371f2';

/// Central ECU: roof (sunroof), HVAC/thermal (cabin model + AUTO fan) and the
/// gateway to non-zonal domain ECUs (powertrain, chassis, ADAS), which confirm
/// the commanded value.

abstract class _$CentralZoneController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
