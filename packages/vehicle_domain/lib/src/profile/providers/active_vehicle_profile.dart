import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../vss/vss_signal.dart';
import '../vehicle_profile.dart';

part 'active_vehicle_profile.g.dart';

/// Perfil com que o veículo inicia. Cada app sobrescreve no `ProviderScope`.
@Riverpod(keepAlive: true)
VehicleProfile initialVehicleProfile(Ref ref) =>
    throw UnimplementedError('Sobrescreva initialVehicleProfileProvider no ProviderScope do app.');

/// Perfil ativo. Trocar o perfil reinicia o [VssBroker] com os sinais do novo modelo.
@Riverpod(keepAlive: true)
class ActiveVehicleProfile extends _$ActiveVehicleProfile {
  @override
  VehicleProfile build() => ref.watch(initialVehicleProfileProvider);

  void setProfile(VehicleProfile profile) => state = profile;
}

/// Se o sinal existe no perfil ativo. Só notifica quando a resposta muda.
@riverpod
bool isSignalSupported(Ref ref, VssSignal<Object> signal) =>
    ref.watch(activeVehicleProfileProvider.select((profile) => profile.supports(signal)));
