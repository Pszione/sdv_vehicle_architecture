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

/// Every rule of the vehicle.
///
/// A rule only runs if its `target` exists in the active profile, so the list
/// can be universal: a car without a lockable differential never reaches
/// [DiffLockSafetyRule]. Override it in the app only to change thresholds per model.
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
