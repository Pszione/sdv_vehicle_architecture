import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Valet Mode: locks the glovebox and frunk, freezes driving settings and caps speed.
final class ValetModeSafetyRule implements SafetyRule {
  ValetModeSafetyRule({required this.target, required this.isBlocked, required this.reason});

  static const maxSpeedKmh = 80.0;

  static List<ValetModeSafetyRule> all() => [
    ValetModeSafetyRule(
      target: Vss.Vehicle.Cabin.Glovebox.IsLocked,
      isBlocked: (value) => value == false,
      reason: 'The glovebox stays locked in Valet Mode.',
    ),
    ValetModeSafetyRule(
      target: Vss.Vehicle.Body.Trunk.Front.IsOpen,
      isBlocked: (value) => value == true,
      reason: 'The frunk stays locked in Valet Mode.',
    ),
    ValetModeSafetyRule(
      target: Vss.Vehicle.ADAS.ESC.Mode,
      isBlocked: (_) => true,
      reason: 'Stability control settings are locked in Valet Mode.',
    ),
    ValetModeSafetyRule(
      target: Vss.Vehicle.DriveMode,
      isBlocked: (_) => true,
      reason: 'Drive mode is locked in Valet Mode.',
    ),
    for (final speedSetting in [Vss.Vehicle.ADAS.ACC.SetSpeed, Vss.Vehicle.ADAS.SpeedLimiter.SetSpeed])
      ValetModeSafetyRule(
        target: speedSetting,
        isBlocked: (value) => (value as double) > maxSpeedKmh,
        reason: 'Valet Mode caps speed at ${maxSpeedKmh.toInt()} km/h.',
      ),
  ];

  @override
  final VssSignal<Object> target;
  final bool Function(Object value) isBlocked;
  final String reason;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Cabin.ValetMode.IsEnabled};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (!(signals.read(Vss.Vehicle.Cabin.ValetMode.IsEnabled) ?? false)) return null;
    return isBlocked(command.value) ? CommandResult.rejected(reason) : null;
  }
}
