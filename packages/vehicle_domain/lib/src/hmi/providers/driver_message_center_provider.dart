import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../logger/domain/log_entry.dart';
import '../../logger/domain/logger_state.dart';
import '../../logger/vehicle_logger.dart';
import '../../power/power_mode.dart';
import '../../power/providers/power_mode_provider.dart';
import '../driver_message_center.dart';

part 'driver_message_center_provider.g.dart';

/// Cluster message center. Turns what the vehicle does into short driver messages:
/// rejected requests (warnings), lost signals (faults, until they recover), automatic
/// behaviors and power mode changes (information that fades out).
@Riverpod(keepAlive: true)
class DriverMessageCenter extends _$DriverMessageCenter {
  static const warningDisplayTime = Duration(seconds: 6);
  static const infoDisplayTime = Duration(seconds: 4);

  /// Driver-facing text of the automatic behaviors, by audit-log source.
  static const behaviorMessages = {
    'AUTO_LOCK': 'Doors locked',
    'AUTO_UNLOCK': 'Doors unlocked',
    'WALK_AWAY': 'Doors locked: key out of range',
    'AUTO_PARK': 'PARK engaged: driver door open',
    'AUTO_OFF': 'Vehicle switched off',
    'AUTO_RELEASE': 'Differential unlocked above 40 km/h',
    'ESC_COORDINATOR': 'Stability control adjusted to the differential',
    'AUTO_LEVEL': 'Suspension height adjusted to speed',
    'CRASH_RESPONSE': 'Crash detected: doors unlocked, hazards on',
    'VALET': 'Valet Mode: speed limited',
    'DEFROST': 'Max defrost on',
  };

  final _timers = <String, Timer>{};
  String? _lastSeenEntryId;

  @override
  DriverMessageQueue build() {
    ref.listen<LoggerState>(vehicleLoggerProvider, (_, next) => _onLogEntries(next.entries));
    ref.listen(powerModeProvider, (previous, next) => _onPowerMode(previous, next));
    ref.onDispose(() {
      for (final timer in _timers.values) {
        timer.cancel();
      }
    });
    return const DriverMessageQueue();
  }

  void post(DriverMessage message) {
    state = state.post(message);
    _timers.remove(message.id)?.cancel();
    if (message.displayFor case final duration?) {
      _timers[message.id] = Timer(duration, () {
        if (ref.mounted) acknowledge(message.id);
      });
    }
  }

  void acknowledge(String id) {
    _timers.remove(id)?.cancel();
    state = state.remove(id);
  }

  void _onLogEntries(List<LogEntry> entries) {
    final lastSeen = _lastSeenEntryId;
    final start = lastSeen == null ? 0 : entries.lastIndexWhere((entry) => entry.id == lastSeen) + 1;
    if (entries.isNotEmpty) _lastSeenEntryId = entries.last.id;
    for (final entry in entries.skip(start)) {
      _onLogEntry(entry);
    }
  }

  void _onLogEntry(LogEntry entry) {
    switch (entry.type) {
      case LogType.safetyRejection:
        post(
          DriverMessage(
            id: 'rejected:${entry.vssPath}',
            text: entry.detailMessage ?? 'Request rejected',
            severity: DriverMessageSeverity.warning,
            displayFor: warningDisplayTime,
          ),
        );
      case LogType.signalFault when entry.payload == 'VALID':
        acknowledge('signal:${entry.vssPath}');
      case LogType.signalFault:
        post(
          DriverMessage(
            id: 'signal:${entry.vssPath}',
            text: '${_shortName(entry.vssPath)} signal ${'${entry.payload}'.toLowerCase()}: related functions limited',
            severity: DriverMessageSeverity.fault,
          ),
        );
      case LogType.command when behaviorMessages.containsKey(entry.source):
        post(
          DriverMessage(
            id: 'behavior:${entry.source}',
            text: behaviorMessages[entry.source]!,
            severity: DriverMessageSeverity.info,
            displayFor: infoDisplayTime,
          ),
        );
      case LogType.command || LogType.signalChange || LogType.forced || LogType.manual:
        break;
    }
  }

  void _onPowerMode(PowerMode? previous, PowerMode? next) {
    if (next == previous) return;
    final text = switch (next) {
      PowerMode.ready => 'Ready to drive',
      PowerMode.charging => 'Charging',
      PowerMode.softwareUpdate => 'Software update in progress',
      _ => null,
    };
    if (text == null) return;
    post(DriverMessage(id: 'power', text: text, severity: DriverMessageSeverity.info, displayFor: infoDisplayTime));
  }

  /// Driver-facing names of the supervised signals.
  static const _signalNames = {
    'Vehicle.Speed': 'Vehicle speed',
    'Vehicle.Chassis.Brake.PedalPosition': 'Brake pedal',
    'Vehicle.Chassis.SteeringWheel.Angle': 'Steering angle',
    'Vehicle.Powertrain.TractionBattery.Charging.IsConnected': 'Charging cable',
    'Vehicle.Body.IsCrashDetected': 'Crash sensor',
    'Vehicle.ADAS.ObstacleDetection.Front.Center.Distance': 'Front radar',
    'Vehicle.ADAS.LaneKeepingAssist.LateralOffset': 'Front camera',
    'Vehicle.ADAS.LaneKeepingAssist.Curvature': 'Front camera',
  };

  static String _shortName(String path) => _signalNames[path] ?? path.split('.').last;
}
