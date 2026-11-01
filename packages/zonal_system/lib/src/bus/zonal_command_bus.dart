import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/vehicle_zone.dart';
import '../domain/zonal_command.dart';

part 'zonal_command_bus.g.dart';

/// Barramento de comandos entre o gateway central e as ECUs zonais.
///
/// É um stream de eventos, e não estado do Riverpod: todo comando é entregue,
/// inclusive dois comandos seguidos no mesmo frame.
final class ZonalCommandBus {
  final _controller = StreamController<ZonalCommand>.broadcast(sync: true);

  void emit(ZonalCommand command) => _controller.add(command);

  Stream<ZonalCommand> commandsFor(VehicleZone zone) =>
      _controller.stream.where((command) => command.targetZone == zone);

  Future<void> dispose() => _controller.close();
}

@Riverpod(keepAlive: true)
ZonalCommandBus zonalCommandBus(Ref ref) {
  final bus = ZonalCommandBus();
  ref.onDispose(bus.dispose);
  return bus;
}
