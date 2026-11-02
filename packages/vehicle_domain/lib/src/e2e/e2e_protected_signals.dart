import '../vss/vss.dart';
import '../vss/vss_signal.dart';

/// Signals that safety rules or the cluster depend on, sent cyclically and protected end to
/// end (counter + CRC) from the sensor ECU to the central gateway. Each has its own Data ID.
abstract final class E2eProtectedSignals {
  /// Cycle of the sending ECUs (real chassis signals: 10–20 ms; slowed down for the simulation).
  static const cycleTime = Duration(milliseconds: 100);

  /// Deadline monitoring: a signal without a frame for this long is stale (3 lost cycles + margin).
  /// Must stay above the gaps E2E itself classifies (a counter jump), or losses would only look stale.
  static const timeout = Duration(milliseconds: 400);

  static final Map<VssSignal<Object>, int> dataIds = {
    Vss.Vehicle.Speed: 0x101,
    Vss.Vehicle.Chassis.Brake.PedalPosition: 0x102,
    Vss.Vehicle.Chassis.SteeringWheel.Angle: 0x103,
    Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected: 0x104,
    Vss.Vehicle.Body.IsCrashDetected: 0x105,
    Vss.Vehicle.ADAS.ObstacleDetection.Front.Center.Distance: 0x201,
    Vss.Vehicle.ADAS.LaneKeepingAssist.LateralOffset: 0x202,
    Vss.Vehicle.ADAS.LaneKeepingAssist.Curvature: 0x203,
  };

  static bool isProtected(VssSignal<Object> signal) => dataIds.containsKey(signal);
}
