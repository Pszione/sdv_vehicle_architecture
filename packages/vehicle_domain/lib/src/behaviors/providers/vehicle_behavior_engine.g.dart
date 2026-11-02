// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_behavior_engine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every automatic behavior of the vehicle. Like safety rules, a behavior whose
/// commands target signals the profile lacks simply gets `notSupported` from the dispatcher.

@ProviderFor(activeVehicleBehaviors)
final activeVehicleBehaviorsProvider = ActiveVehicleBehaviorsProvider._();

/// Every automatic behavior of the vehicle. Like safety rules, a behavior whose
/// commands target signals the profile lacks simply gets `notSupported` from the dispatcher.

final class ActiveVehicleBehaviorsProvider
    extends $FunctionalProvider<List<VehicleBehavior>, List<VehicleBehavior>, List<VehicleBehavior>>
    with $Provider<List<VehicleBehavior>> {
  /// Every automatic behavior of the vehicle. Like safety rules, a behavior whose
  /// commands target signals the profile lacks simply gets `notSupported` from the dispatcher.
  ActiveVehicleBehaviorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeVehicleBehaviorsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeVehicleBehaviorsHash();

  @$internal
  @override
  $ProviderElement<List<VehicleBehavior>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<VehicleBehavior> create(Ref ref) {
    return activeVehicleBehaviors(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<VehicleBehavior> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<VehicleBehavior>>(value));
  }
}

String _$activeVehicleBehaviorsHash() => r'3fb42c39a01ee5482a085750f48ba6b66fbea269';

/// Runs the behaviors: watches the broker and dispatches what they decide.
/// Read it at app boot, like the zonal ECUs.

@ProviderFor(VehicleBehaviorEngine)
final vehicleBehaviorEngineProvider = VehicleBehaviorEngineProvider._();

/// Runs the behaviors: watches the broker and dispatches what they decide.
/// Read it at app boot, like the zonal ECUs.
final class VehicleBehaviorEngineProvider extends $NotifierProvider<VehicleBehaviorEngine, void> {
  /// Runs the behaviors: watches the broker and dispatches what they decide.
  /// Read it at app boot, like the zonal ECUs.
  VehicleBehaviorEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleBehaviorEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleBehaviorEngineHash();

  @$internal
  @override
  VehicleBehaviorEngine create() => VehicleBehaviorEngine();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$vehicleBehaviorEngineHash() => r'690829ac31dc179b0c7dae5cb812ffc7e23b9f77';

/// Runs the behaviors: watches the broker and dispatches what they decide.
/// Read it at app boot, like the zonal ECUs.

abstract class _$VehicleBehaviorEngine extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
