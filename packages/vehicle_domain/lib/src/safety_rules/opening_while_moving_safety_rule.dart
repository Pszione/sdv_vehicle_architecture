import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';
import 'domain/safety_rule.dart';

/// Body openings (power doors, tailgate, frunk, charge port flap) cannot open while the car is moving.
final class OpeningWhileMovingSafetyRule implements SafetyRule {
  OpeningWhileMovingSafetyRule({required this.target, required this.label, required this.isOpening});

  static const maxSpeedKmh = 3.0;

  static List<OpeningWhileMovingSafetyRule> all() => [
    for (final door in VehicleGroups.doors)
      OpeningWhileMovingSafetyRule(target: door.open, label: '${door.label} door', isOpening: (value) => value == true),
    OpeningWhileMovingSafetyRule(
      target: Vss.Vehicle.Body.Trunk.Rear.IsOpen,
      label: 'Tailgate',
      isOpening: (value) => value == true,
    ),
    OpeningWhileMovingSafetyRule(
      target: Vss.Vehicle.Body.Trunk.Front.IsOpen,
      label: 'Frunk',
      isOpening: (value) => value == true,
    ),
    OpeningWhileMovingSafetyRule(
      target: Vss.Vehicle.Powertrain.TractionBattery.Charging.ChargePortFlap,
      label: 'Charge port',
      isOpening: (value) => value == ChargePortFlapState.open,
    ),
  ];

  @override
  final VssSignal<Object> target;
  final String label;
  final bool Function(Object value) isOpening;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Speed};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (!isOpening(command.value)) return null;

    final speed = signals.read(Vss.Vehicle.Speed) ?? 0.0;
    if (speed > maxSpeedKmh) {
      return CommandResult.rejected('$label cannot open while moving (current: ${speed.toInt()} km/h).');
    }
    return null;
  }
}
