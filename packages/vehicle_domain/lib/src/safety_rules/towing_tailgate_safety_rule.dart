import '../broker/signal_reader.dart';
import '../dispatcher/domain/vehicle_commands.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import 'domain/safety_rule.dart';

/// The power tailgate stays closed while a trailer is connected (it could hit the trailer).
final class TowingTailgateSafetyRule implements SafetyRule {
  @override
  VssSignal<bool> get target => Vss.Vehicle.Body.Trunk.Rear.IsOpen;

  @override
  Set<VssSignal<Object>> get inputs => {Vss.Vehicle.Body.Trailer.IsConnected};

  @override
  CommandResult? validate(VehicleCommand<Object> command, SignalReader signals) {
    if (command.value != true) return null;

    if (signals.read(Vss.Vehicle.Body.Trailer.IsConnected) ?? false) {
      return const CommandResult.rejected('Power tailgate is disabled while a trailer is connected.');
    }
    return null;
  }
}
