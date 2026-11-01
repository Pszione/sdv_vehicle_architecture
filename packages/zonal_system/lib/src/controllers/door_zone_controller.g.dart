// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'door_zone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Side zone ECU (west/east): door locks on that side.

@ProviderFor(DoorZoneController)
final doorZoneControllerProvider = DoorZoneControllerFamily._();

/// Side zone ECU (west/east): door locks on that side.
final class DoorZoneControllerProvider
    extends $NotifierProvider<DoorZoneController, void> {
  /// Side zone ECU (west/east): door locks on that side.
  DoorZoneControllerProvider._({
    required DoorZoneControllerFamily super.from,
    required VehicleZone super.argument,
  }) : super(
         retry: null,
         name: r'doorZoneControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$doorZoneControllerHash();

  @override
  String toString() {
    return r'doorZoneControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DoorZoneController create() => DoorZoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DoorZoneControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$doorZoneControllerHash() =>
    r'e4ca7721221685e12ae402648fa4e52fe6a7a898';

/// Side zone ECU (west/east): door locks on that side.

final class DoorZoneControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DoorZoneController,
          void,
          void,
          void,
          VehicleZone
        > {
  DoorZoneControllerFamily._()
    : super(
        retry: null,
        name: r'doorZoneControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Side zone ECU (west/east): door locks on that side.

  DoorZoneControllerProvider call(VehicleZone zone) =>
      DoorZoneControllerProvider._(argument: zone, from: this);

  @override
  String toString() => r'doorZoneControllerProvider';
}

/// Side zone ECU (west/east): door locks on that side.

abstract class _$DoorZoneController extends $Notifier<void> {
  late final _$args = ref.$arg as VehicleZone;
  VehicleZone get zone => _$args;

  void build(VehicleZone zone);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
