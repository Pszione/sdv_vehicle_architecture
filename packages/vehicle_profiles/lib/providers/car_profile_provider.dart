import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/vehicle_profile.dart';

part 'active_vehicle_profile_provider.g.dart';

@riverpod
class ActiveVehicleProfile extends _$ActiveVehicleProfile {
  // --- MOCK DOS PERFIS DE FÁBRICA ---

  static final basicProfile = VehicleProfile(
    id: 'entry_level',
    trimName: 'Versão Básica (Comfort)',
    supportedCapabilities: {
      Vss.Vehicle.Speed,
      Vss.Vehicle.Cabin.Door.Row1.Left.IsLocked,
      Vss.Vehicle.Cabin.Door.Row1.Left.IsAjar,
      // NOTA: Sem teto solar nem massagem nos bancos
    },
  );

  static final premiumProfile = VehicleProfile(
    id: 'top_level',
    trimName: 'Versão Premium (Highline)',
    supportedCapabilities: {
      Vss.Vehicle.Speed,
      Vss.Vehicle.Cabin.Door.Row1.Left.IsLocked,
      Vss.Vehicle.Cabin.Door.Row1.Left.IsAjar,
      Vss.Vehicle.Cabin.Sunroof.Position,
      Vss.Vehicle.Cabin.Sunroof.IsFaulted,
    },
  );

  @override
  VehicleProfile build() {
    return basicProfile; // Inicia por padrão na versão Básica
  }

  /// Altera o perfil do veículo ao vivo
  void setProfile(VehicleProfile newProfile) {
    state = newProfile;

    // Opcional: Invalida/limpa sinais do broker que não existem na nova versão
    ref.read(vssBrokerProvider.notifier).resetToProfile(newProfile.supportedCapabilities);
  }
}