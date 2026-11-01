import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../profile/providers/active_vehicle_profile.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';

part 'vss_broker.g.dart';

enum SignalWriteResult { accepted, unchanged, notSupported, outOfRange }

/// Estado confirmado do veículo: último valor de cada sinal do perfil ativo,
/// indexado pelo caminho VSS.
///
/// Só as ECUs zonais e os simuladores publicam aqui. A UI nunca escreve:
/// ela envia um `VehicleCommand` ao `CommandDispatcher`.
/// Para ler um sinal na UI, use `vssValueProvider`, que é granular.
@Riverpod(keepAlive: true)
class VssBroker extends _$VssBroker {
  @override
  Map<String, Object?> build() {
    final profile = ref.watch(activeVehicleProfileProvider);
    return {for (final path in profile.supportedPaths) path: vssCatalog[path]!.defaultValue};
  }

  /// Publica telemetria confirmada. Valores fora do spec são descartados e
  /// reportados, e valores repetidos não notificam ninguém.
  SignalWriteResult publish<T extends Object>(VssSignal<T> signal, T value) {
    final meta = ref.read(activeVehicleProfileProvider).metaOf(signal);
    if (meta == null) return SignalWriteResult.notSupported;
    if (!meta.accepts(value)) {
      developer.log('Telemetria fora do spec descartada: $signal = $value', name: 'VssBroker');
      return SignalWriteResult.outOfRange;
    }
    if (state[signal.path] == value) return SignalWriteResult.unchanged;

    state = {...state, signal.path: value};
    return SignalWriteResult.accepted;
  }
}
