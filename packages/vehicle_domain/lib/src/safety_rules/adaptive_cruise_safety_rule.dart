import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../profile/vehicle_profile.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// Adaptive cruise control only engages in DRIVE, between 30 and 180 km/h,
/// with every door closed and the driver seatbelt fastened.
final class AdaptiveCruiseSafetyRule implements SafetyRule {
  AdaptiveCruiseSafetyRule(this.driverSide);

  static const minSpeedKmh = 30.0;
  static const maxSpeedKmh = 180.0;

  final DriverSide driverSide;

  @override
  VssSignal<bool> get target => Vss.Vehicle.ADAS.ACC.IsEngaged;

  @override
  Set<VssSignal<Object>> get inputs => {
    Vss.Vehicle.Powertrain.Transmission.SelectedGear,
    Vss.Vehicle.Speed,
    VehicleGroups.driverSeat(driverSide).belted,
    for (final door in VehicleGroups.doors) door.ajar,
  };

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;

    if (signals.read(Vss.Vehicle.Powertrain.Transmission.SelectedGear) != Gear.drive) {
      return const CommandResult.rejected('Adaptive cruise control requires DRIVE.');
    }
    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (speed < minSpeedKmh || speed > maxSpeedKmh) {
      return CommandResult.rejected(
        'Adaptive cruise control works between ${minSpeedKmh.toInt()} and ${maxSpeedKmh.toInt()} km/h '
        '(current: ${speed.toInt()} km/h).',
      );
    }
    for (final door in VehicleGroups.doors) {
      if (signals.read(door.ajar) ?? false) {
        return CommandResult.rejected('${door.label} door is open. Close it to engage cruise control.');
      }
    }
    if (!(signals.read(VehicleGroups.driverSeat(driverSide).belted) ?? true)) {
      return const CommandResult.rejected('Fasten the driver seatbelt to engage cruise control.');
    }
    return null;
  }
}
