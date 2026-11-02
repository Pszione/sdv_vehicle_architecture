import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'power_mode.dart';

/// Which power modes each vehicle function is available in ("functional availability").
///
/// The `CommandValidator` checks it before the safety rules: availability answers
/// "does this function exist right now?", the rules answer "is it safe right now?".
/// Signals not listed (locks, doors, openings, power requests) are always available:
/// the body zones wake up for them. Securing the vehicle is always available too:
/// PARK, the parking brake, and switching any function off.
abstract final class PowerModeAvailability {
  static const _always = {...PowerMode.values};
  static const _driving = {PowerMode.ready};
  static const _poweredOn = {PowerMode.on, PowerMode.ready};
  static const _comfort = {PowerMode.accessory, PowerMode.on, PowerMode.ready};
  static const _climate = {PowerMode.accessory, PowerMode.on, PowerMode.ready, PowerMode.charging};

  /// Ordered by specificity: the first matching path prefix wins.
  static const _table = <(String, Set<PowerMode>)>[
    ('Vehicle.Powertrain.Transmission.SelectedGear', _poweredOn),
    ('Vehicle.ADAS.CruiseControl.', _driving),
    ('Vehicle.ADAS.LaneKeepingAssist.', _driving),
    ('Vehicle.ADAS.HillDescentControl.', _driving),
    ('Vehicle.ADAS.', _poweredOn),
    ('Vehicle.Chassis.SteeringWheel.HeatingCooling', _climate),
    ('Vehicle.Chassis.ParkingBrake.', _always),
    ('Vehicle.Chassis.', _poweredOn),
    ('Vehicle.DriveMode', _poweredOn),
    ('Vehicle.Cabin.HVAC.DogMode.', _comfort),
    ('Vehicle.Cabin.HVAC.CampMode.', _comfort),
    ('Vehicle.Cabin.HVAC.', _climate),
    ('Vehicle.Cabin.Seat.', _climate),
    ('Vehicle.Cabin.AmbientLighting.', _comfort),
    ('Vehicle.Cabin.HeadUpDisplay.', _poweredOn),
    ('Vehicle.Media.', _comfort),
    ('Vehicle.Powertrain.TractionBattery.Preconditioning.', _climate),
    ('Vehicle.Powertrain.V2L.', _comfort),
    ('Vehicle.Software.OTA.IsInstalling', {PowerMode.off, PowerMode.softwareUpdate}),
  ];

  /// Modes [signal] is available in, or `null` when it is always available.
  static Set<PowerMode>? of(VssSignal<Object> signal) {
    for (final (prefix, modes) in _table) {
      if (signal.path.startsWith(prefix)) return modes;
    }
    return null;
  }

  /// Switching a function off (`false`) and shifting to PARK are always available, so nothing
  /// can stay stuck on and the car can always be secured.
  static bool allows(VssSignal<Object> signal, Object value, PowerMode mode) {
    if (value == false) return true;
    if (signal == Vss.Vehicle.Powertrain.Transmission.SelectedGear && value == Gear.park) return true;
    return of(signal)?.contains(mode) ?? true;
  }

  /// Driver-facing hint, e.g. "Available when the vehicle is ON or READY."
  static String hint(Set<PowerMode> modes) {
    final labels = [
      for (final mode in PowerMode.values)
        if (modes.contains(mode)) mode.label,
    ];
    final list = labels.length == 1
        ? labels.single
        : '${labels.sublist(0, labels.length - 1).join(', ')} or ${labels.last}';
    return 'Available when the vehicle is $list.';
  }
}
