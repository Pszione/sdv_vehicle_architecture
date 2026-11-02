// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_message_center_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cluster message center. Turns what the vehicle does into short driver messages:
/// rejected requests (warnings), lost signals (faults, until they recover), automatic
/// behaviors and power mode changes (information that fades out).

@ProviderFor(DriverMessageCenter)
final driverMessageCenterProvider = DriverMessageCenterProvider._();

/// Cluster message center. Turns what the vehicle does into short driver messages:
/// rejected requests (warnings), lost signals (faults, until they recover), automatic
/// behaviors and power mode changes (information that fades out).
final class DriverMessageCenterProvider extends $NotifierProvider<DriverMessageCenter, DriverMessageQueue> {
  /// Cluster message center. Turns what the vehicle does into short driver messages:
  /// rejected requests (warnings), lost signals (faults, until they recover), automatic
  /// behaviors and power mode changes (information that fades out).
  DriverMessageCenterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'driverMessageCenterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$driverMessageCenterHash();

  @$internal
  @override
  DriverMessageCenter create() => DriverMessageCenter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriverMessageQueue value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DriverMessageQueue>(value));
  }
}

String _$driverMessageCenterHash() => r'7c682eaabc4948e1a4b41eaf190c69bb3102ddc1';

/// Cluster message center. Turns what the vehicle does into short driver messages:
/// rejected requests (warnings), lost signals (faults, until they recover), automatic
/// behaviors and power mode changes (information that fades out).

abstract class _$DriverMessageCenter extends $Notifier<DriverMessageQueue> {
  DriverMessageQueue build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DriverMessageQueue, DriverMessageQueue>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DriverMessageQueue, DriverMessageQueue>,
              DriverMessageQueue,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
