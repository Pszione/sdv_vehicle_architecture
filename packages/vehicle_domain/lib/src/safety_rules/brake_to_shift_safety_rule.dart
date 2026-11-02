import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// Leaving PARK requires the brake pedal to be pressed.
final class BrakeToShiftSafetyRule implements SafetyRule {
  static const minPedalPercent = 10;

  @override
  VssSignal<int> get target => Vss.Vehicle.Powertrain.Transmission.SelectedGear;

  @override
  Set<VssSignal<Object>> get inputs => {target, Vss.Vehicle.Chassis.Brake.PedalPosition};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (signals.read(target) != Gear.park || command.value == Gear.park) return null;

    // Without a pedal sensor reading, assume the pedal is released (fail-safe).
    final pedal = signals.read(Vss.Vehicle.Chassis.Brake.PedalPosition) ?? 0;
    if (pedal < minPedalPercent) {
      return const CommandResult.rejected('Press the brake pedal to shift out of PARK.');
    }
    return null;
  }
}
