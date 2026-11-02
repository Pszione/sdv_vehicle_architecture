import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../broker/signal_reader.dart';
import '../../broker/vss_broker.dart';
import '../../dispatcher/command_dispatcher.dart';
import '../auto_park_behavior.dart';
import '../auto_parking_brake_behavior.dart';
import '../auto_power_off_behavior.dart';
import '../climate_sync_behavior.dart';
import '../crash_response_behavior.dart';
import '../diff_lock_auto_release_behavior.dart';
import '../diff_lock_esc_behavior.dart';
import '../empty_seat_climate_behavior.dart';
import '../max_defrost_behavior.dart';
import '../domain/vehicle_behavior.dart';
import '../park_auto_unlock_behavior.dart';
import '../speed_auto_lock_behavior.dart';
import '../suspension_auto_level_behavior.dart';
import '../valet_speed_cap_behavior.dart';
import '../walk_away_lock_behavior.dart';

part 'vehicle_behavior_engine.g.dart';

/// Every automatic behavior of the vehicle. Like safety rules, a behavior whose
/// commands target signals the profile lacks simply gets `notSupported` from the dispatcher.
@Riverpod(keepAlive: true)
List<VehicleBehavior> activeVehicleBehaviors(Ref ref) => [
  SpeedAutoLockBehavior(),
  ParkAutoUnlockBehavior(),
  DiffLockAutoReleaseBehavior(),
  DiffLockEscBehavior(),
  AutoParkBehavior(),
  SuspensionAutoLevelBehavior(),
  CrashResponseBehavior(),
  ValetSpeedCapBehavior(),
  ClimateSyncBehavior(),
  MaxDefrostBehavior(),
  EmptySeatClimateBehavior(),
  WalkAwayLockBehavior(),
  AutoPowerOffBehavior(),
  AutoParkingBrakeBehavior(),
];

/// Runs the behaviors: watches the broker and dispatches what they decide.
/// Read it at app boot, like the zonal ECUs.
@Riverpod(keepAlive: true)
class VehicleBehaviorEngine extends _$VehicleBehaviorEngine {
  @override
  void build() {
    final behaviors = ref.watch(activeVehicleBehaviorsProvider);

    ref.listen<Map<String, Object?>>(vssBrokerProvider, (previous, next) {
      // A profile switch rebuilds the whole state: not a real-world change, so nothing reacts.
      if (previous == null || previous.length != next.length) return;

      final before = SnapshotSignalReader(previous);
      final after = SnapshotSignalReader(next);
      final commands = [
        for (final behavior in behaviors)
          if (behavior.triggers.any((signal) => previous[signal.path] != next[signal.path]))
            ...behavior.react(before, after),
      ];
      if (commands.isEmpty) return;

      // Next ECU cycle: never dispatch from inside a broker notification.
      scheduleMicrotask(() {
        final dispatcher = ref.read(commandDispatcherProvider.notifier);
        for (final command in commands) {
          dispatcher.dispatch(command);
        }
      });
    });
  }
}
