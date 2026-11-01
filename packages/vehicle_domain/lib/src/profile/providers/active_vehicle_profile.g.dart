// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_vehicle_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Perfil com que o veículo inicia. Cada app sobrescreve no `ProviderScope`.

@ProviderFor(initialVehicleProfile)
final initialVehicleProfileProvider = InitialVehicleProfileProvider._();

/// Perfil com que o veículo inicia. Cada app sobrescreve no `ProviderScope`.

final class InitialVehicleProfileProvider
    extends $FunctionalProvider<VehicleProfile, VehicleProfile, VehicleProfile>
    with $Provider<VehicleProfile> {
  /// Perfil com que o veículo inicia. Cada app sobrescreve no `ProviderScope`.
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
  $ProviderElement<VehicleProfile> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VehicleProfile create(Ref ref) {
    return initialVehicleProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VehicleProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VehicleProfile>(value),
    );
  }
}

String _$initialVehicleProfileHash() =>
    r'6029767b35c765244472fb7fde05cde38027caa8';

/// Perfil ativo. Trocar o perfil reinicia o [VssBroker] com os sinais do novo modelo.

@ProviderFor(ActiveVehicleProfile)
final activeVehicleProfileProvider = ActiveVehicleProfileProvider._();

/// Perfil ativo. Trocar o perfil reinicia o [VssBroker] com os sinais do novo modelo.
final class ActiveVehicleProfileProvider
    extends $NotifierProvider<ActiveVehicleProfile, VehicleProfile> {
  /// Perfil ativo. Trocar o perfil reinicia o [VssBroker] com os sinais do novo modelo.
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
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VehicleProfile>(value),
    );
  }
}

String _$activeVehicleProfileHash() =>
    r'6fb1a199fda4ba116987f95a98a00d7813095812';

/// Perfil ativo. Trocar o perfil reinicia o [VssBroker] com os sinais do novo modelo.

abstract class _$ActiveVehicleProfile extends $Notifier<VehicleProfile> {
  VehicleProfile build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VehicleProfile, VehicleProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VehicleProfile, VehicleProfile>,
              VehicleProfile,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Se o sinal existe no perfil ativo. Só notifica quando a resposta muda.

@ProviderFor(isSignalSupported)
final isSignalSupportedProvider = IsSignalSupportedFamily._();

/// Se o sinal existe no perfil ativo. Só notifica quando a resposta muda.

final class IsSignalSupportedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Se o sinal existe no perfil ativo. Só notifica quando a resposta muda.
  IsSignalSupportedProvider._({
    required IsSignalSupportedFamily super.from,
    required VssSignal<Object> super.argument,
  }) : super(
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
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as VssSignal<Object>;
    return isSignalSupported(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
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

/// Se o sinal existe no perfil ativo. Só notifica quando a resposta muda.

final class IsSignalSupportedFamily extends $Family
    with $FunctionalFamilyOverride<bool, VssSignal<Object>> {
  IsSignalSupportedFamily._()
    : super(
        retry: null,
        name: r'isSignalSupportedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Se o sinal existe no perfil ativo. Só notifica quando a resposta muda.

  IsSignalSupportedProvider call(VssSignal<Object> signal) =>
      IsSignalSupportedProvider._(argument: signal, from: this);

  @override
  String toString() => r'isSignalSupportedProvider';
}
