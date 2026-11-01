import 'package:vehicle_domain/vehicle_domain.dart';

import '../domain/zonal_command.dart';
import '../domain/zonal_route.dart';
import 'zonal_command_bus.dart';

/// Liga o `CommandDispatcher` ao barramento zonal, resolvendo a rota de cada sinal.
final class ZonalCommandSink implements CommandSink {
  const ZonalCommandSink(this._bus);

  final ZonalCommandBus _bus;

  @override
  void send(VehicleCommand<Object> command) {
    final route = ZonalRoute.of(command.signal);
    _bus.emit(ZonalCommand(targetZone: route.zone, deviceId: route.deviceId, command: command));
  }
}
