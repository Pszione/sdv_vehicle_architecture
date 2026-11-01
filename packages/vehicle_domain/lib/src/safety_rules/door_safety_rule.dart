import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// Bloqueia o travamento de uma porta que está aberta. Destravar é sempre permitido.
///
/// Usa o lado físico (Left/Right), por isso vale igual para LHD e RHD.
final class DoorSafetyRule implements SafetyRule {
  DoorSafetyRule({required VssSignal<bool> lock, required this.ajar, required this.label}) : target = lock;

  /// Uma regra por porta do spec.
  static List<DoorSafetyRule> allDoors() {
    final door = Vss.Vehicle.Cabin.Door;
    return [
      DoorSafetyRule(lock: door.Row1.Left.IsLocked, ajar: door.Row1.Left.IsAjar, label: 'dianteira esquerda'),
      DoorSafetyRule(lock: door.Row1.Right.IsLocked, ajar: door.Row1.Right.IsAjar, label: 'dianteira direita'),
      DoorSafetyRule(lock: door.Row2.Left.IsLocked, ajar: door.Row2.Left.IsAjar, label: 'traseira esquerda'),
      DoorSafetyRule(lock: door.Row2.Right.IsLocked, ajar: door.Row2.Right.IsAjar, label: 'traseira direita'),
    ];
  }

  @override
  final VssSignal<bool> target;
  final VssSignal<bool> ajar;
  final String label;

  @override
  Set<VssSignal<Object>> get inputs => {ajar};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;
    if (signals.read(ajar) ?? false) {
      return CommandResult.rejected('Porta $label está aberta. Trava bloqueada.');
    }
    return null;
  }
}
