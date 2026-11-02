import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../power/power_mode.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// Leaving PARK needs the high voltage connected (READY). Shifting to PARK is always allowed.
final class ReadyToShiftSafetyRule implements SafetyRule {
  @override
  VssSignal<int> get target => Vss.Vehicle.Powertrain.Transmission.SelectedGear;

  @override
  Set<VssSignal<Object>> get inputs => PowerMode.inputs;

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value == Gear.park) return null;

    final mode = PowerMode.from(signals);
    if (mode != null && mode != PowerMode.ready) {
      return CommandResult.rejected('Vehicle is ${mode.label}, not READY. Press the brake and START.');
    }
    return null;
  }
}
