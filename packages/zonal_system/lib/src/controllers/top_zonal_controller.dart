import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../actuators/dumb_sunroof_actuator.dart';
import '../domain/actuator_state.dart';
import '../domain/zonal_command.dart';

part 'top_zone_controller.g.dart';

@riverpod
class TopZoneController extends _$TopZoneController {
  final DumbSunroofActuator _sunroof = DumbSunroofActuator('SUNROOF_ACTUATOR');
  StreamSubscription<ActuatorPositionProgress>? _movementSubscription;

  @override
  void build() {
    // Escuta comandos no Barramento Zonal
    ref.listen<AsyncValue<ZonalCommand>>(zonalCommandBusProvider, (previous, next) {
      next.whenData((command) {
        if (command.targetZone == 'ZONE_TOP') {
          _processCommand(command);
        }
      });
    });

    ref.onDispose(() => _movementSubscription?.cancel());
  }

  /// Método utilitário para injeção de falha via painel de testes/simulador
  void injectSunroofFault(ActuatorFaultType fault) {
    _sunroof.injectFault(fault);
  }

  void _processCommand(ZonalCommand command) {
    if (command.deviceId == _sunroof.id && command.vssPath == 'Vehicle.Cabin.Sunroof.Position') {
      final double targetPos = (command.actionPayload as num).toDouble();

      // Cancela movimentação anterior se um novo comando chegar
      _movementSubscription?.cancel();

      // Inicia a movimentação física assíncrona
      _movementSubscription = _sunroof.moveTo(targetPos).listen((progress) {
        // 1. Atualiza a posição em tempo real no VssBroker (0.0 -> 0.1 -> 0.2 ...)
        ref.read(vssBrokerProvider.notifier).setSignal(
          'Vehicle.Cabin.Sunroof.Position',
          progress.position,
        );

        // 2. Se ocorreu uma falha, notifica o sinal VSS de Diagnóstico (DTC)
        if (progress.state == ActuatorState.stuck || progress.state == ActuatorState.fault) {
          print('[TopZoneController] FALHA NO ATUADOR: ${progress.fault} na posição ${progress.position}');

          ref.read(vssBrokerProvider.notifier).setSignal(
            'Vehicle.Cabin.Sunroof.IsFaulted',
            true,
          );
        } else {
          ref.read(vssBrokerProvider.notifier).setSignal(
            'Vehicle.Cabin.Sunroof.IsFaulted',
            false,
          );
        }
      });
    }
  }
}