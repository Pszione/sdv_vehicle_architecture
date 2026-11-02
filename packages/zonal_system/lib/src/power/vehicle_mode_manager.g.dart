// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_mode_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Vehicle mode manager (VMM), hosted by the central zone: owns the 12 V supply state
/// (`LowVoltageSystemState`), the high-voltage contactors (`IsPowerConnected`) and the
/// 12 V battery model.
///
/// It executes power requests that the dispatcher already approved
/// (`PowerModeRequestSafetyRule`), with realistic timing:
/// - READY: 12 V goes to START, the HV bus pre-charges for [prechargeTime], then the contactors close.
/// - OFF after driving: retained accessory power ([retainedAccessoryTime]) until a door opens.
/// - Key gone and car off: the car sleeps (12 V LOCK) after [sleepDelay].
///
/// Times are shortened so the simulation is watchable (real cars: minutes instead of seconds).

@ProviderFor(VehicleModeManager)
final vehicleModeManagerProvider = VehicleModeManagerProvider._();

/// Vehicle mode manager (VMM), hosted by the central zone: owns the 12 V supply state
/// (`LowVoltageSystemState`), the high-voltage contactors (`IsPowerConnected`) and the
/// 12 V battery model.
///
/// It executes power requests that the dispatcher already approved
/// (`PowerModeRequestSafetyRule`), with realistic timing:
/// - READY: 12 V goes to START, the HV bus pre-charges for [prechargeTime], then the contactors close.
/// - OFF after driving: retained accessory power ([retainedAccessoryTime]) until a door opens.
/// - Key gone and car off: the car sleeps (12 V LOCK) after [sleepDelay].
///
/// Times are shortened so the simulation is watchable (real cars: minutes instead of seconds).
final class VehicleModeManagerProvider extends $NotifierProvider<VehicleModeManager, void> {
  /// Vehicle mode manager (VMM), hosted by the central zone: owns the 12 V supply state
  /// (`LowVoltageSystemState`), the high-voltage contactors (`IsPowerConnected`) and the
  /// 12 V battery model.
  ///
  /// It executes power requests that the dispatcher already approved
  /// (`PowerModeRequestSafetyRule`), with realistic timing:
  /// - READY: 12 V goes to START, the HV bus pre-charges for [prechargeTime], then the contactors close.
  /// - OFF after driving: retained accessory power ([retainedAccessoryTime]) until a door opens.
  /// - Key gone and car off: the car sleeps (12 V LOCK) after [sleepDelay].
  ///
  /// Times are shortened so the simulation is watchable (real cars: minutes instead of seconds).
  VehicleModeManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleModeManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleModeManagerHash();

  @$internal
  @override
  VehicleModeManager create() => VehicleModeManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$vehicleModeManagerHash() => r'9e6fc19193ee1ebf5af79296bdccfe2f47d8b2b2';

/// Vehicle mode manager (VMM), hosted by the central zone: owns the 12 V supply state
/// (`LowVoltageSystemState`), the high-voltage contactors (`IsPowerConnected`) and the
/// 12 V battery model.
///
/// It executes power requests that the dispatcher already approved
/// (`PowerModeRequestSafetyRule`), with realistic timing:
/// - READY: 12 V goes to START, the HV bus pre-charges for [prechargeTime], then the contactors close.
/// - OFF after driving: retained accessory power ([retainedAccessoryTime]) until a door opens.
/// - Key gone and car off: the car sleeps (12 V LOCK) after [sleepDelay].
///
/// Times are shortened so the simulation is watchable (real cars: minutes instead of seconds).

abstract class _$VehicleModeManager extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
