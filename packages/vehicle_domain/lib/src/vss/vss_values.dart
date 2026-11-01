/// Allowed values of string VSS signals, so rules and behaviors never repeat literals.
/// They must match the `allowed` lists in `vehicle.vss.json`.
abstract final class Gear {
  static const park = 'PARK';
  static const reverse = 'REVERSE';
  static const neutral = 'NEUTRAL';
  static const drive = 'DRIVE';
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
