// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vss_broker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Estado confirmado do veículo: último valor de cada sinal do perfil ativo,
/// indexado pelo caminho VSS.
///
/// Só as ECUs zonais e os simuladores publicam aqui. A UI nunca escreve:
/// ela envia um `VehicleCommand` ao `CommandDispatcher`.
/// Para ler um sinal na UI, use `vssValueProvider`, que é granular.

@ProviderFor(VssBroker)
final vssBrokerProvider = VssBrokerProvider._();

/// Estado confirmado do veículo: último valor de cada sinal do perfil ativo,
/// indexado pelo caminho VSS.
///
/// Só as ECUs zonais e os simuladores publicam aqui. A UI nunca escreve:
/// ela envia um `VehicleCommand` ao `CommandDispatcher`.
/// Para ler um sinal na UI, use `vssValueProvider`, que é granular.
final class VssBrokerProvider
    extends $NotifierProvider<VssBroker, Map<String, Object?>> {
  /// Estado confirmado do veículo: último valor de cada sinal do perfil ativo,
  /// indexado pelo caminho VSS.
  ///
  /// Só as ECUs zonais e os simuladores publicam aqui. A UI nunca escreve:
  /// ela envia um `VehicleCommand` ao `CommandDispatcher`.
  /// Para ler um sinal na UI, use `vssValueProvider`, que é granular.
  VssBrokerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vssBrokerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vssBrokerHash();

  @$internal
  @override
  VssBroker create() => VssBroker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Object?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Object?>>(value),
    );
  }
}

String _$vssBrokerHash() => r'3c4b92f593631ee703c0b00dc3f7ecdb84ac00e3';

/// Estado confirmado do veículo: último valor de cada sinal do perfil ativo,
/// indexado pelo caminho VSS.
///
/// Só as ECUs zonais e os simuladores publicam aqui. A UI nunca escreve:
/// ela envia um `VehicleCommand` ao `CommandDispatcher`.
/// Para ler um sinal na UI, use `vssValueProvider`, que é granular.

abstract class _$VssBroker extends $Notifier<Map<String, Object?>> {
  Map<String, Object?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, Object?>, Map<String, Object?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, Object?>, Map<String, Object?>>,
              Map<String, Object?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
