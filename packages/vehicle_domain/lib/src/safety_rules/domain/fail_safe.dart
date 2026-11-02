import '../../dispatcher/domain/vehicle_commands.dart';

/// Answers of the safety rules when an input they need is not available (lost, corrupted,
/// or its sender is asleep). The rule rejects: a missing speed is treated as "moving",
/// never as 0 km/h. Releasing actions (unlock, close, disengage) stay allowed because the
/// rules return early for them, before reading any input.
abstract final class FailSafe {
  static const speedUnavailable = CommandResult.rejected(
    'Vehicle speed unavailable. Not allowed until it is valid again.',
  );
  static const steeringUnavailable = CommandResult.rejected(
    'Steering angle unavailable. Not allowed until it is valid again.',
  );
  static const chargingCableUnavailable = CommandResult.rejected(
    'Charging cable status unavailable. Not allowed until it is valid again.',
  );
}
