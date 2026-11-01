import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../convertible_top_safety_rule.dart';
import '../diff_lock_safety_rule.dart';
import '../domain/safety_rule.dart';
import '../door_safety_rule.dart';
import '../ev_charging_safety_rule.dart';
import '../ev_preconditioning_safety_rule.dart';
import '../sunroof_speed_safety_rule.dart';
import '../suv_air_suspension_safety_rule.dart';
import '../transmission_safety_rule.dart';

part 'safety_rules_provider.g.dart';

/// Todas as regras do veículo.
///
/// Uma regra só roda se o seu `target` existe no perfil ativo, então a lista
/// pode ser universal: um carro sem diferencial bloqueável nunca chega à
/// [DiffLockSafetyRule]. Sobrescreva no app só para mudar limiares por modelo.
@Riverpod(keepAlive: true)
List<SafetyRule> activeSafetyRules(Ref ref) => [
  ...DoorSafetyRule.allDoors(),
  SunroofSpeedSafetyRule(),
  TransmissionSafetyRule(),
  EvChargingSafetyRule(),
  EvPreconditioningSafetyRule(),
  DiffLockSafetyRule(),
  SuvAirSuspensionSafetyRule(),
  ConvertibleTopSafetyRule(),
];
