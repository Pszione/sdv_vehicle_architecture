import 'dart:async';

import '../domain/actuator_state.dart';

class ActuatorPositionProgress {
  final double position;
  final ActuatorState state;
  final ActuatorFaultType fault;

  ActuatorPositionProgress({
    required this.position,
    required this.state,
    this.fault = ActuatorFaultType.none,
  });
}

class DumbSunroofActuator {
  final String id;
  double _currentPosition = 0.0; // 0.0 (fechado) a 1.0 (totalmente aberto)
  ActuatorState _state = ActuatorState.idle;
  ActuatorFaultType _injectedFault = ActuatorFaultType.none;

  DumbSunroofActuator(this.id);

  double get position => _currentPosition;

  ActuatorState get state => _state;

  /// Permite injetar uma falha deliberadamente para testes (Fault Injection)
  void injectFault(ActuatorFaultType fault) {
    _injectedFault = fault;
  }

  /// Executa a movimentação física com latência calculada
  Stream<ActuatorPositionProgress> moveTo(double targetPosition, {double speedPerSecond = 0.25}) async* {
    targetPosition = targetPosition.clamp(0.0, 1.0);

    if ((_currentPosition - targetPosition).abs() < 0.01) {
      yield ActuatorPositionProgress(position: _currentPosition, state: ActuatorState.idle);
      return;
    }

    _state = ActuatorState.moving;
    yield ActuatorPositionProgress(position: _currentPosition, state: _state);

    const stepIntervalMs = 100; // Atualizações a cada 100ms (10Hz)
    final stepDelta = speedPerSecond * (stepIntervalMs / 1000.0);

    while (_state == ActuatorState.moving) {
      await Future.delayed(const Duration(milliseconds: stepIntervalMs));

      // 1. Simulação de Falha Mecânica (Jamming/Obstáculo) no meio do percurso
      if (_injectedFault == ActuatorFaultType.mechanicalJam &&
          _currentPosition >= 0.5 &&
          targetPosition > _currentPosition) {
        _state = ActuatorState.stuck;
        yield ActuatorPositionProgress(
          position: _currentPosition,
          state: _state,
          fault: ActuatorFaultType.mechanicalJam,
        );
        return;
      }

      // 2. Simulação de Timeout Elétrico
      if (_injectedFault == ActuatorFaultType.hardwareTimeout) {
        _state = ActuatorState.fault;
        yield ActuatorPositionProgress(
          position: _currentPosition,
          state: _state,
          fault: ActuatorFaultType.hardwareTimeout,
        );
        return;
      }

      // 3. Incremento/Decremento da posição física
      if (_currentPosition < targetPosition) {
        _currentPosition = (_currentPosition + stepDelta).clamp(0.0, targetPosition);
      } else {
        _currentPosition = (_currentPosition - stepDelta).clamp(targetPosition, 1.0);
      }

      // Chegou ao destino?
      if ((_currentPosition - targetPosition).abs() < 0.001) {
        _currentPosition = targetPosition;
        _state = ActuatorState.idle;
      }

      yield ActuatorPositionProgress(position: _currentPosition, state: _state);
    }
  }

  void stop() {
    _state = ActuatorState.idle;
  }
}
