// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driving_simulator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Simple longitudinal and lateral model at 30 Hz (the rate of a camera/radar ECU), feeding
/// the cluster's ADAS view: ego speed with adaptive cruise gap control, a lead vehicle, lane
/// geometry, forward-collision and lane-departure warnings, traction power, odometer and SoC.
///
/// It only moves the car while it is READY in DRIVE. State: the profile being played, or `null`.

@ProviderFor(DrivingSimulator)
final drivingSimulatorProvider = DrivingSimulatorProvider._();

/// Simple longitudinal and lateral model at 30 Hz (the rate of a camera/radar ECU), feeding
/// the cluster's ADAS view: ego speed with adaptive cruise gap control, a lead vehicle, lane
/// geometry, forward-collision and lane-departure warnings, traction power, odometer and SoC.
///
/// It only moves the car while it is READY in DRIVE. State: the profile being played, or `null`.
final class DrivingSimulatorProvider extends $NotifierProvider<DrivingSimulator, DriveProfile?> {
  /// Simple longitudinal and lateral model at 30 Hz (the rate of a camera/radar ECU), feeding
  /// the cluster's ADAS view: ego speed with adaptive cruise gap control, a lead vehicle, lane
  /// geometry, forward-collision and lane-departure warnings, traction power, odometer and SoC.
  ///
  /// It only moves the car while it is READY in DRIVE. State: the profile being played, or `null`.
  DrivingSimulatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drivingSimulatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drivingSimulatorHash();

  @$internal
  @override
  DrivingSimulator create() => DrivingSimulator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriveProfile? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DriveProfile?>(value));
  }
}

String _$drivingSimulatorHash() => r'5f16eb3453172491797ade8d4c2a9f0900bbbb98';

/// Simple longitudinal and lateral model at 30 Hz (the rate of a camera/radar ECU), feeding
/// the cluster's ADAS view: ego speed with adaptive cruise gap control, a lead vehicle, lane
/// geometry, forward-collision and lane-departure warnings, traction power, odometer and SoC.
///
/// It only moves the car while it is READY in DRIVE. State: the profile being played, or `null`.

abstract class _$DrivingSimulator extends $Notifier<DriveProfile?> {
  DriveProfile? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DriveProfile?, DriveProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<DriveProfile?, DriveProfile?>, DriveProfile?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
