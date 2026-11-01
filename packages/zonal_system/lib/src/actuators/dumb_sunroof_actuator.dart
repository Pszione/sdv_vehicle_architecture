import 'dart:async';

import '../domain/actuator_state.dart';

class ActuatorPositionProgress {
  final double position;
  final ActuatorState state;
  final ActuatorFaultType fault;

  ActuatorPositionProgress({required this.position, required this.state, this.fault = ActuatorFaultType.none});
}

class DumbSunroofActuator {
  final String id;
  double _currentPosition = 0.0; // 0.0 (closed) to 1.0 (fully open)
  ActuatorState _state = ActuatorState.idle;
  ActuatorFaultType _injectedFault = ActuatorFaultType.none;

  DumbSunroofActuator(this.id);

  double get position => _currentPosition;

  ActuatorState get state => _state;

  /// Deliberately injects a fault for testing (fault injection).
  void injectFault(ActuatorFaultType fault) {
    _injectedFault = fault;
  }

  /// Runs the physical movement with simulated latency.
  Stream<ActuatorPositionProgress> moveTo(double targetPosition, {double speedPerSecond = 0.25}) async* {
    targetPosition = targetPosition.clamp(0.0, 1.0);

    if ((_currentPosition - targetPosition).abs() < 0.01) {
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
        _currentPosition = (_currentPosition + stepDelta).clamp(0.0, targetPosition);
      } else {
        _currentPosition = (_currentPosition - stepDelta).clamp(targetPosition, 1.0);
      }

      // Target reached?
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
