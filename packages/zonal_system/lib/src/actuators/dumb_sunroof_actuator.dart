import 'dart:async';

import '../domain/actuator_state.dart';

class ActuatorPositionProgress {
  /// Percent: 0 = closed, 100 = fully open, -100 = fully tilted (COVESA `Sunroof.Position`).
  final double position;
  final ActuatorState state;
  final ActuatorFaultType fault;

  ActuatorPositionProgress({required this.position, required this.state, this.fault = ActuatorFaultType.none});
}

class DumbSunroofActuator {
  final String id;
  double _currentPosition = 0; // percent, -100 (tilted) .. 0 (closed) .. 100 (open)
  ActuatorState _state = ActuatorState.idle;
  ActuatorFaultType _injectedFault = ActuatorFaultType.none;

  DumbSunroofActuator(this.id);

  double get position => _currentPosition;

  ActuatorState get state => _state;

  /// Deliberately injects a fault for testing (fault injection).
  void injectFault(ActuatorFaultType fault) {
    _injectedFault = fault;
  }

  /// Runs the physical movement with simulated latency. [targetPosition] and [speedPerSecond] in percent.
  Stream<ActuatorPositionProgress> moveTo(double targetPosition, {double speedPerSecond = 25}) async* {
    targetPosition = targetPosition.clamp(-100, 100);

    if ((_currentPosition - targetPosition).abs() < 1) {
      yield ActuatorPositionProgress(position: _currentPosition, state: ActuatorState.idle);
      return;
    }

    _state = ActuatorState.moving;
    yield ActuatorPositionProgress(position: _currentPosition, state: _state);

    const stepIntervalMs = 100; // Updates every 100 ms (10 Hz)
    final stepDelta = speedPerSecond * (stepIntervalMs / 1000.0);

    while (_state == ActuatorState.moving) {
      await Future.delayed(const Duration(milliseconds: stepIntervalMs));

      // 1. Mechanical fault (jam/obstacle) halfway through the travel
      if (_injectedFault == ActuatorFaultType.mechanicalJam &&
          _currentPosition >= 50 &&
          targetPosition > _currentPosition) {
        _state = ActuatorState.stuck;
        yield ActuatorPositionProgress(
          position: _currentPosition,
          state: _state,
          fault: ActuatorFaultType.mechanicalJam,
        );
        return;
      }

      // 2. Electrical timeout
      if (_injectedFault == ActuatorFaultType.hardwareTimeout) {
        _state = ActuatorState.fault;
        yield ActuatorPositionProgress(
          position: _currentPosition,
          state: _state,
          fault: ActuatorFaultType.hardwareTimeout,
        );
        return;
      }

      // 3. Move the physical position
      if (_currentPosition < targetPosition) {
        _currentPosition = (_currentPosition + stepDelta).clamp(-100, targetPosition);
      } else {
        _currentPosition = (_currentPosition - stepDelta).clamp(targetPosition, 100);
      }

      // Target reached?
      if ((_currentPosition - targetPosition).abs() < 0.1) {
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
