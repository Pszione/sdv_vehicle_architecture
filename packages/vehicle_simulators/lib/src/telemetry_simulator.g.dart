// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_simulator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Simulated world around the car, with four clearly separated paths:
///
/// - [report]: a **sensor** reading (speed, seat occupancy, SoC...) published to the [VssBroker],
///   as an ECU would. Actuators are refused. E2E-protected sensors (speed, brake pedal...) go
///   through an [E2eTransmitter] to the gateway's `E2eReceiver`, cyclically, and can be
///   corrupted with [injectE2eFault].
/// - [command]: an **actuator** request that goes through the `CommandDispatcher`, so every
///   safety rule applies (source `SIMULATOR`).
/// - [operateManually]: a person moving an actuator by hand (door handle, manual tailgate).
///   No command exists, so no rule applies; the zone ECU reports the latch. Logged as `MANUAL`.
/// - [forceActuatorState]: test-only override that writes an actuator state directly,
///   **bypassing every rule**, and logs it as `FORCED` in the audit log.

@ProviderFor(TelemetrySimulator)
final telemetrySimulatorProvider = TelemetrySimulatorProvider._();

/// Simulated world around the car, with four clearly separated paths:
///
/// - [report]: a **sensor** reading (speed, seat occupancy, SoC...) published to the [VssBroker],
///   as an ECU would. Actuators are refused. E2E-protected sensors (speed, brake pedal...) go
///   through an [E2eTransmitter] to the gateway's `E2eReceiver`, cyclically, and can be
///   corrupted with [injectE2eFault].
/// - [command]: an **actuator** request that goes through the `CommandDispatcher`, so every
///   safety rule applies (source `SIMULATOR`).
/// - [operateManually]: a person moving an actuator by hand (door handle, manual tailgate).
///   No command exists, so no rule applies; the zone ECU reports the latch. Logged as `MANUAL`.
/// - [forceActuatorState]: test-only override that writes an actuator state directly,
///   **bypassing every rule**, and logs it as `FORCED` in the audit log.
final class TelemetrySimulatorProvider extends $NotifierProvider<TelemetrySimulator, void> {
  /// Simulated world around the car, with four clearly separated paths:
  ///
  /// - [report]: a **sensor** reading (speed, seat occupancy, SoC...) published to the [VssBroker],
  ///   as an ECU would. Actuators are refused. E2E-protected sensors (speed, brake pedal...) go
  ///   through an [E2eTransmitter] to the gateway's `E2eReceiver`, cyclically, and can be
  ///   corrupted with [injectE2eFault].
  /// - [command]: an **actuator** request that goes through the `CommandDispatcher`, so every
  ///   safety rule applies (source `SIMULATOR`).
  /// - [operateManually]: a person moving an actuator by hand (door handle, manual tailgate).
  ///   No command exists, so no rule applies; the zone ECU reports the latch. Logged as `MANUAL`.
  /// - [forceActuatorState]: test-only override that writes an actuator state directly,
  ///   **bypassing every rule**, and logs it as `FORCED` in the audit log.
  TelemetrySimulatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetrySimulatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetrySimulatorHash();

  @$internal
  @override
  TelemetrySimulator create() => TelemetrySimulator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$telemetrySimulatorHash() => r'77d30148a64f6d4c024c2a682af8d383aa018c0b';

/// Simulated world around the car, with four clearly separated paths:
///
/// - [report]: a **sensor** reading (speed, seat occupancy, SoC...) published to the [VssBroker],
///   as an ECU would. Actuators are refused. E2E-protected sensors (speed, brake pedal...) go
///   through an [E2eTransmitter] to the gateway's `E2eReceiver`, cyclically, and can be
///   corrupted with [injectE2eFault].
/// - [command]: an **actuator** request that goes through the `CommandDispatcher`, so every
///   safety rule applies (source `SIMULATOR`).
/// - [operateManually]: a person moving an actuator by hand (door handle, manual tailgate).
///   No command exists, so no rule applies; the zone ECU reports the latch. Logged as `MANUAL`.
/// - [forceActuatorState]: test-only override that writes an actuator state directly,
///   **bypassing every rule**, and logs it as `FORCED` in the audit log.

abstract class _$TelemetrySimulator extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
