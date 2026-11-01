import 'vehicle_commands.dart';

/// Destino dos comandos aprovados pelo dispatcher.
///
/// O domínio não conhece a topologia E/E: o `zonal_system` implementa esta
/// interface e o app faz a ligação no `ProviderScope`.
abstract interface class CommandSink {
  void send(VehicleCommand<Object> command);
}
