import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../adaptive_cruise_safety_rule.dart';
import '../brake_to_shift_safety_rule.dart';
import '../charge_cable_lock_safety_rule.dart';
import '../climate_range_protection_safety_rule.dart';
import '../convertible_top_safety_rule.dart';
import '../diff_lock_safety_rule.dart';
import '../domain/safety_rule.dart';
import '../door_latch_safety_rule.dart';
import '../door_safety_rule.dart';
import '../driver_presence_safety_rule.dart';
import '../esc_mode_safety_rule.dart';
import '../ev_charging_safety_rule.dart';
import '../ev_preconditioning_safety_rule.dart';
import '../opening_while_moving_safety_rule.dart';
import '../ota_install_safety_rule.dart';
import '../parked_mode_safety_rule.dart';
import '../rear_climate_lock_safety_rule.dart';
import '../speed_window_safety_rule.dart';
import '../sunroof_speed_safety_rule.dart';
import '../suv_air_suspension_safety_rule.dart';
import '../towing_tailgate_safety_rule.dart';
import '../transmission_safety_rule.dart';
import '../valet_mode_safety_rule.dart';

part 'safety_rules_provider.g.dart';

/// Every rule of the vehicle.
///
/// A rule only runs if its `target` exists in the active profile, so the list
/// can be universal: a car without a lockable differential never reaches
/// [DiffLockSafetyRule].
/// Override it in the app only to change thresholds per model.
@Riverpod(keepAlive: true)
List<SafetyRule> activeSafetyRules(Ref ref) => [
  ...DoorSafetyRule.allDoors(),
  ...DoorLatchSafetyRule.allDoors(),
  SunroofSpeedSafetyRule(),
  TransmissionSafetyRule(),
  BrakeToShiftSafetyRule(),
  DriverPresenceSafetyRule(),
  EvChargingSafetyRule(),
  EvPreconditioningSafetyRule(),
  DiffLockSafetyRule(),
  EscModeSafetyRule(),
  SuvAirSuspensionSafetyRule(),
  ConvertibleTopSafetyRule(),
  ...OpeningWhileMovingSafetyRule.all(),
  TowingTailgateSafetyRule(),
  ChargeCableLockSafetyRule(),
  AdaptiveCruiseSafetyRule(),
  ...SpeedWindowSafetyRule.all(),
  ...ParkedModeSafetyRule.all(),
  OtaInstallSafetyRule(),
  ...ValetModeSafetyRule.all(),
  ...RearClimateLockSafetyRule.all(),
  ...ClimateRangeProtectionSafetyRule.all(),
];
