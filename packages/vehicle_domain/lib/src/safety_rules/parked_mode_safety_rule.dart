import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// Stationary modes (Dog, Camp, Sentry, V2L) only switch on in PARK, with enough
/// traction battery left and a healthy 12 V battery (they keep control units awake).
final class ParkedModeSafetyRule implements SafetyRule {
  ParkedModeSafetyRule({required this.target, required this.label, required this.isActivation, this.minSoc = 20});

  /// Below this the 12 V battery could not restart the car after hours awake.
  static const minLowVoltage = 11.8;

  static List<ParkedModeSafetyRule> all() => [
    ParkedModeSafetyRule(
      target: Vss.Vehicle.Cabin.HVAC.DogMode.IsEnabled,
      label: 'Dog Mode',
      isActivation: (value) => value == true,
    ),
    ParkedModeSafetyRule(
      target: Vss.Vehicle.Cabin.HVAC.CampMode.IsEnabled,
      label: 'Camp Mode',
      isActivation: (value) => value == true,
    ),
    ParkedModeSafetyRule(
      target: Vss.Vehicle.Cabin.Sentry.Mode,
      label: 'Sentry Mode',
      isActivation: (value) => value != SentryMode.off,
    ),
    ParkedModeSafetyRule(
      target: Vss.Vehicle.Powertrain.V2L.IsExportingPower,
      label: 'Vehicle-to-load',
      isActivation: (value) => value == true,
    ),
  ];

  @override
  final VssSignal<Object> target;
  final String label;
  final bool Function(Object value) isActivation;
  final double minSoc;

  @override
  Set<VssSignal<Object>> get inputs => {
    Vss.Vehicle.Powertrain.Transmission.SelectedGear,
    Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge,
    Vss.Vehicle.LowVoltageBattery.CurrentVoltage,
  };

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (!isActivation(command.value)) return null;

    if (signals.read(Vss.Vehicle.Powertrain.Transmission.SelectedGear) != Gear.park) {
      return CommandResult.rejected('$label is only available in PARK.');
    }
    final soc = signals.read(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge) ?? 0.0;
    if (soc < minSoc) {
      return CommandResult.rejected('$label needs at least ${minSoc.toInt()}% battery (current: ${soc.toInt()}%).');
    }
    final lowVoltage = signals.read(Vss.Vehicle.LowVoltageBattery.CurrentVoltage);
    if (lowVoltage != null && lowVoltage < minLowVoltage) {
      return CommandResult.rejected('$label is unavailable: 12 V battery low (${lowVoltage.toStringAsFixed(1)} V).');
    }
    return null;
  }
}
