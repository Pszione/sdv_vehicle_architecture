import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// OTA installation: in PARK, SoC above 30%, every door locked and nobody inside.
final class OtaInstallSafetyRule implements SafetyRule {
  static const minSoc = 30.0;

  @override
  VssSignal<bool> get target => Vss.Vehicle.Software.OTA.IsInstalling;

  @override
  Set<VssSignal<Object>> get inputs => {
    Vss.Vehicle.Powertrain.Transmission.SelectedGear,
    Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge,
    for (final door in VehicleGroups.doors) door.lock,
    for (final seat in VehicleGroups.seats) seat.occupied,
  };

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;

    if (signals.read(Vss.Vehicle.Powertrain.Transmission.SelectedGear) != Gear.park) {
      return const CommandResult.rejected('Software updates install only in PARK.');
    }
    final soc = signals.read(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge) ?? 0.0;
    if (soc <= minSoc) {
      return CommandResult.rejected(
        'Software updates need more than ${minSoc.toInt()}% battery (current: ${soc.toInt()}%).',
      );
    }
    for (final door in VehicleGroups.doors) {
      if (!(signals.read(door.lock) ?? false)) {
        return CommandResult.rejected('${door.label} door is unlocked. Lock every door to install the update.');
      }
    }
    for (final seat in VehicleGroups.seats) {
      if (signals.read(seat.occupied) ?? false) {
        return CommandResult.rejected('${seat.label} seat is occupied. Nobody can be inside during the update.');
      }
    }
    return null;
  }
}
