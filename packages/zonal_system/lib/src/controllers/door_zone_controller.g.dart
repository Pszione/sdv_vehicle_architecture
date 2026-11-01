// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'door_zone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ECU de uma zona lateral (west/east): travas das portas daquele lado.

@ProviderFor(DoorZoneController)
final doorZoneControllerProvider = DoorZoneControllerFamily._();

/// ECU de uma zona lateral (west/east): travas das portas daquele lado.
final class DoorZoneControllerProvider
    extends $NotifierProvider<DoorZoneController, void> {
  /// ECU de uma zona lateral (west/east): travas das portas daquele lado.
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

/// ECU de uma zona lateral (west/east): travas das portas daquele lado.

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

  /// ECU de uma zona lateral (west/east): travas das portas daquele lado.

  DoorZoneControllerProvider call(VehicleZone zone) =>
      DoorZoneControllerProvider._(argument: zone, from: this);

  @override
  String toString() => r'doorZoneControllerProvider';
}

/// ECU de uma zona lateral (west/east): travas das portas daquele lado.

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
