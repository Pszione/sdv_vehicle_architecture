// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_zone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ECU genérica para atuadores ainda sem simulação física (HVAC, bancos,
/// suspensão...): confirma o valor comandado como telemetria, sem latência.
///
/// Quando um atuador ganhar um modelo próprio (como o teto solar), ele deve
/// ir para um controlador dedicado e sair da rota desta zona.

@ProviderFor(GenericZoneController)
final genericZoneControllerProvider = GenericZoneControllerFamily._();

/// ECU genérica para atuadores ainda sem simulação física (HVAC, bancos,
/// suspensão...): confirma o valor comandado como telemetria, sem latência.
///
/// Quando um atuador ganhar um modelo próprio (como o teto solar), ele deve
/// ir para um controlador dedicado e sair da rota desta zona.
final class GenericZoneControllerProvider
    extends $NotifierProvider<GenericZoneController, void> {
  /// ECU genérica para atuadores ainda sem simulação física (HVAC, bancos,
  /// suspensão...): confirma o valor comandado como telemetria, sem latência.
  ///
  /// Quando um atuador ganhar um modelo próprio (como o teto solar), ele deve
  /// ir para um controlador dedicado e sair da rota desta zona.
  GenericZoneControllerProvider._({
    required GenericZoneControllerFamily super.from,
    required VehicleZone super.argument,
  }) : super(
         retry: null,
         name: r'genericZoneControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$genericZoneControllerHash();

  @override
  String toString() {
    return r'genericZoneControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GenericZoneController create() => GenericZoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericZoneControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$genericZoneControllerHash() =>
    r'19df8c5fc40df3fb286ebce9608e0069814e5b31';

/// ECU genérica para atuadores ainda sem simulação física (HVAC, bancos,
/// suspensão...): confirma o valor comandado como telemetria, sem latência.
///
/// Quando um atuador ganhar um modelo próprio (como o teto solar), ele deve
/// ir para um controlador dedicado e sair da rota desta zona.

final class GenericZoneControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          GenericZoneController,
          void,
          void,
          void,
          VehicleZone
        > {
  GenericZoneControllerFamily._()
    : super(
        retry: null,
        name: r'genericZoneControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// ECU genérica para atuadores ainda sem simulação física (HVAC, bancos,
  /// suspensão...): confirma o valor comandado como telemetria, sem latência.
  ///
  /// Quando um atuador ganhar um modelo próprio (como o teto solar), ele deve
  /// ir para um controlador dedicado e sair da rota desta zona.

  GenericZoneControllerProvider call(VehicleZone zone) =>
      GenericZoneControllerProvider._(argument: zone, from: this);

  @override
  String toString() => r'genericZoneControllerProvider';
}

/// ECU genérica para atuadores ainda sem simulação física (HVAC, bancos,
/// suspensão...): confirma o valor comandado como telemetria, sem latência.
///
/// Quando um atuador ganhar um modelo próprio (como o teto solar), ele deve
/// ir para um controlador dedicado e sair da rota desta zona.

abstract class _$GenericZoneController extends $Notifier<void> {
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
