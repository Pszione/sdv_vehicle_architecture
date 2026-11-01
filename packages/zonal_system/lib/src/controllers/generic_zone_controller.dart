import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../bus/zonal_command_bus.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_command.dart';

part 'generic_zone_controller.g.dart';

/// ECU genérica para atuadores ainda sem simulação física (HVAC, bancos,
/// suspensão...): confirma o valor comandado como telemetria, sem latência.
///
/// Quando um atuador ganhar um modelo próprio (como o teto solar), ele deve
/// ir para um controlador dedicado e sair da rota desta zona.
@Riverpod(keepAlive: true)
class GenericZoneController extends _$GenericZoneController {
  @override
  void build(VehicleZone zone) {
    final commands = ref.watch(zonalCommandBusProvider).commandsFor(zone).listen(_process);
    ref.onDispose(commands.cancel);
  }

  void _process(ZonalCommand command) =>
      ref.read(vssBrokerProvider.notifier).publish(command.signal, command.command.value);
}
