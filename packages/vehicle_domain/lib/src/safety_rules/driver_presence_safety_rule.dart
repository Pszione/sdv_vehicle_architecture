import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../profile/vehicle_profile.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// No DRIVE/REVERSE with the driver door open or the driver seatbelt unfastened.
final class DriverPresenceSafetyRule implements SafetyRule {
  DriverPresenceSafetyRule(this.driverSide);

  static const _movingGears = {Gear.drive, Gear.reverse};

  final DriverSide driverSide;

  @override
  VssSignal<String> get target => Vss.Vehicle.Powertrain.Transmission.SelectedGear;

  @override
  Set<VssSignal<Object>> get inputs {
    final door = VehicleGroups.driverDoor(driverSide);
    final seat = VehicleGroups.driverSeat(driverSide);
    return {door.ajar, seat.belted};
  }

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (!_movingGears.contains(command.value)) return null;

    if (signals.read(VehicleGroups.driverDoor(driverSide).ajar) ?? false) {
      return CommandResult.rejected('Close the driver door before engaging ${command.value}.');
    }
    // Cars without a belt sensor (signal not in the profile) are not blocked.
    if (!(signals.read(VehicleGroups.driverSeat(driverSide).belted) ?? true)) {
      return CommandResult.rejected('Fasten the driver seatbelt before engaging ${command.value}.');
    }
    return null;
  }
}
