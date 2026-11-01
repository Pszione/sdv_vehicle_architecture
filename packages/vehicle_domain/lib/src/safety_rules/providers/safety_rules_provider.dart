import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/safety_rule.dart';

part 'active_safety_rules_provider.g.dart';

@riverpod
List<SafetyRule> activeSafetyRules(Ref ref) {
  // Regras universais ativas por padrão em todos os veículos
  return [
    DoorSafetyRule(),
    SunroofSpeedSafetyRule(),
    TransmissionSafetyRule(),
  ];
}