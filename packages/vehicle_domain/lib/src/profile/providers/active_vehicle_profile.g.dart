// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_vehicle_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Profile the vehicle boots with. Every app overrides it in its `ProviderScope`.

@ProviderFor(initialVehicleProfile)
final initialVehicleProfileProvider = InitialVehicleProfileProvider._();

/// Profile the vehicle boots with. Every app overrides it in its `ProviderScope`.

final class InitialVehicleProfileProvider extends $FunctionalProvider<VehicleProfile, VehicleProfile, VehicleProfile>
    with $Provider<VehicleProfile> {
  /// Profile the vehicle boots with. Every app overrides it in its `ProviderScope`.
  InitialVehicleProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialVehicleProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialVehicleProfileHash();

  @$internal
  @override
  $ProviderElement<VehicleProfile> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  VehicleProfile create(Ref ref) {
    return initialVehicleProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VehicleProfile value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<VehicleProfile>(value));
  }
}

String _$initialVehicleProfileHash() => r'88ab32d68a21a7f16fc7a279f73a7d2003db2224';

/// Active profile. Switching it resets the [VssBroker] to the new model's signals.

@ProviderFor(ActiveVehicleProfile)
final activeVehicleProfileProvider = ActiveVehicleProfileProvider._();

/// Active profile. Switching it resets the [VssBroker] to the new model's signals.
final class ActiveVehicleProfileProvider extends $NotifierProvider<ActiveVehicleProfile, VehicleProfile> {
  /// Active profile. Switching it resets the [VssBroker] to the new model's signals.
  ActiveVehicleProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeVehicleProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeVehicleProfileHash();

  @$internal
  @override
  ActiveVehicleProfile create() => ActiveVehicleProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VehicleProfile value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<VehicleProfile>(value));
  }
}

String _$activeVehicleProfileHash() => r'6fb1a199fda4ba116987f95a98a00d7813095812';

/// Active profile. Switching it resets the [VssBroker] to the new model's signals.

abstract class _$ActiveVehicleProfile extends $Notifier<VehicleProfile> {
  VehicleProfile build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VehicleProfile, VehicleProfile>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<VehicleProfile, VehicleProfile>, VehicleProfile, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Whether the signal exists in the active profile. Only notifies when the answer changes.

@ProviderFor(isSignalSupported)
final isSignalSupportedProvider = IsSignalSupportedFamily._();

/// Whether the signal exists in the active profile. Only notifies when the answer changes.

final class IsSignalSupportedProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether the signal exists in the active profile. Only notifies when the answer changes.
  IsSignalSupportedProvider._({required IsSignalSupportedFamily super.from, required VssSignal<Object> super.argument})
    : super(
        retry: null,
        name: r'isSignalSupportedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSignalSupportedHash();

  @override
  String toString() {
    return r'isSignalSupportedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as VssSignal<Object>;
    return isSignalSupported(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is IsSignalSupportedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isSignalSupportedHash() => r'78c389d12b70909a74d7a420ae59b187dc759b9b';

/// Whether the signal exists in the active profile. Only notifies when the answer changes.

final class IsSignalSupportedFamily extends $Family with $FunctionalFamilyOverride<bool, VssSignal<Object>> {
  IsSignalSupportedFamily._()
    : super(
        retry: null,
        name: r'isSignalSupportedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether the signal exists in the active profile. Only notifies when the answer changes.

  IsSignalSupportedProvider call(VssSignal<Object> signal) => IsSignalSupportedProvider._(argument: signal, from: this);

  @override
  String toString() => r'isSignalSupportedProvider';
}
