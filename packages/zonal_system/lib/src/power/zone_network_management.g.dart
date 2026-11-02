// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_network_management.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps each zone awake while someone needs it, and lets it sleep otherwise.
///
/// Every zone is awake unless the car is in [PowerMode.sleep]. While asleep, a zone stays
/// awake for its "keep-awake" users (Sentry cameras, charging, OTA, Camp/Dog Mode), and a
/// command to a sleeping zone wakes it ([requestWake]): the frame waits for [wakeUpLatency].

@ProviderFor(ZoneNetworkManagement)
final zoneNetworkManagementProvider = ZoneNetworkManagementProvider._();

/// Keeps each zone awake while someone needs it, and lets it sleep otherwise.
///
/// Every zone is awake unless the car is in [PowerMode.sleep]. While asleep, a zone stays
/// awake for its "keep-awake" users (Sentry cameras, charging, OTA, Camp/Dog Mode), and a
/// command to a sleeping zone wakes it ([requestWake]): the frame waits for [wakeUpLatency].
final class ZoneNetworkManagementProvider extends $NotifierProvider<ZoneNetworkManagement, Map<VehicleZone, NmState>> {
  /// Keeps each zone awake while someone needs it, and lets it sleep otherwise.
  ///
  /// Every zone is awake unless the car is in [PowerMode.sleep]. While asleep, a zone stays
  /// awake for its "keep-awake" users (Sentry cameras, charging, OTA, Camp/Dog Mode), and a
  /// command to a sleeping zone wakes it ([requestWake]): the frame waits for [wakeUpLatency].
  ZoneNetworkManagementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zoneNetworkManagementProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zoneNetworkManagementHash();

  @$internal
  @override
  ZoneNetworkManagement create() => ZoneNetworkManagement();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<VehicleZone, NmState> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Map<VehicleZone, NmState>>(value));
  }
}

String _$zoneNetworkManagementHash() => r'a404ebb9b6b67703f2a1aa77ffd77fe45d58df6d';

/// Keeps each zone awake while someone needs it, and lets it sleep otherwise.
///
/// Every zone is awake unless the car is in [PowerMode.sleep]. While asleep, a zone stays
/// awake for its "keep-awake" users (Sentry cameras, charging, OTA, Camp/Dog Mode), and a
/// command to a sleeping zone wakes it ([requestWake]): the frame waits for [wakeUpLatency].

abstract class _$ZoneNetworkManagement extends $Notifier<Map<VehicleZone, NmState>> {
  Map<VehicleZone, NmState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<VehicleZone, NmState>, Map<VehicleZone, NmState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<VehicleZone, NmState>, Map<VehicleZone, NmState>>,
              Map<VehicleZone, NmState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
