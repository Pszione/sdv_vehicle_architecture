// Named values of enum-like VSS signals, so rules and behaviors never repeat literals.
// String values must match the `allowed` lists in `vehicle.vss.json`.

/// COVESA `Transmission.SelectedGear` (int8): 0 = Neutral, 1..n = forward,
/// -1..-n = reverse, 126 = Park, 127 = Drive.
abstract final class Gear {
  static const park = 126;
  static const reverse = -1;
  static const neutral = 0;
  static const drive = 127;

  /// Readable name for HMIs and rule messages: PARK, REVERSE, NEUTRAL, DRIVE or `GEAR n`.
  static String label(int gear) => switch (gear) {
    park => 'PARK',
    drive => 'DRIVE',
    neutral => 'NEUTRAL',
    reverse => 'REVERSE',
    < 0 => 'REVERSE ${-gear}',
    _ => 'GEAR $gear',
  };
}

abstract final class EscMode {
  static const normal = 'NORMAL';
  static const wet = 'WET';
  static const sportPlus = 'SPORT_PLUS';
  static const off = 'OFF';
}

abstract final class SuspensionHeight {
  static const low = 'LOW';
  static const normal = 'NORMAL';
  static const high = 'HIGH';
  static const offroadMax = 'OFFROAD_MAX';
}

abstract final class ChargePortFlapState {
  static const open = 'OPEN';
  static const closed = 'CLOSED';
}

abstract final class SentryMode {
  static const off = 'OFF';
  static const armed = 'ARMED';
}

abstract final class SeatOccupancy {
  static const unknown = 'UNKNOWN';
  static const occupied = 'OCCUPIED';
  static const empty = 'EMPTY';
}

abstract final class AirDistribution {
  static const up = 'UP';
  static const middle = 'MIDDLE';
  static const down = 'DOWN';
}

abstract final class MassageType {
  static const wave = 'WAVE';
  static const pulse = 'PULSE';
  static const stretch = 'STRETCH';
}
