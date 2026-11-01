import 'vehicle_commands.dart';

/// Destination of the commands approved by the dispatcher.
///
/// The domain does not know the E/E topology: `zonal_system` implements this
/// interface and the app wires it in the `ProviderScope`.
abstract interface class CommandSink {
  void send(VehicleCommand<Object> command);
}
