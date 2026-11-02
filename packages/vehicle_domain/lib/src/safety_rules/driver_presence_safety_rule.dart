import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// No DRIVE/REVERSE with the driver door open or the driver seatbelt unfastened.
final class DriverPresenceSafetyRule implements SafetyRule {
  static const _movingGears = {Gear.drive, Gear.reverse};

  @override
  VssSignal<int> get target => Vss.Vehicle.Powertrain.Transmission.SelectedGear;

  @override
  Set<VssSignal<Object>> get inputs => {VehicleGroups.driverDoor.open, VehicleGroups.driverSeat.belted};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (!_movingGears.contains(command.value)) return null;

    if (signals.read(VehicleGroups.driverDoor.open) ?? false) {
      return CommandResult.rejected('Close the driver door before engaging ${Gear.label(command.value as int)}.');
    }
    // Cars without a belt sensor (signal not in the profile) are not blocked.
    if (!(signals.read(VehicleGroups.driverSeat.belted) ?? true)) {
      return CommandResult.rejected('Fasten the driver seatbelt before engaging ${Gear.label(command.value as int)}.');
    }
    return null;
  }
}
