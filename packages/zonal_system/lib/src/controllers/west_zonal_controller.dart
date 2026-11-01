import '../domain/zonal_command.dart';

@riverpod
class WestZoneController extends _$WestZoneController {
  final DumbDoorActuator _driverDoor = DumbDoorActuator('DOOR_FRONT_LEFT');

  @override
  void build() {
    // Escuta a Stream de comandos do barramento zonal
    ref.listen<AsyncValue<ZonalCommand>>(zonalCommandBusProvider, (previous, next) {
      next.whenData((command) {
        if (command.targetZone == 'ZONE_WEST') {
          _processCommand(command);
        }
      });
    });
  }

  void _processCommand(ZonalCommand command) {
    if (command.deviceId == _driverDoor.id) {
      if (command.vssPath.endsWith('.IsLocked')) {
        // 1. Aplica o sinal elétrico no atuador burro
        _driverDoor.applyLockSignal(command.actionPayload as bool);

        // 2. Confirma a alteração física e envia a telemetria de retorno
        ref.read(vssBrokerProvider.notifier).setSignal(
          command.vssPath,
          _driverDoor.isLocked,
        );

        print('[WestZoneController] Atuador ajustado e confirmado: ${_driverDoor.id} -> IsLocked=${_driverDoor.isLocked}');
      }
    }
  }
}