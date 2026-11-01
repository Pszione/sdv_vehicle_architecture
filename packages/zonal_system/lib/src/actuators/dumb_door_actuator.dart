/// "Dumb" door lock actuator: applies the electrical signal and reports the physical state.
class DumbDoorActuator {
  DumbDoorActuator(this.id);

  final String id;
  bool _isLocked = false;

  bool get isLocked => _isLocked;

  void applyLockSignal(bool lock) => _isLocked = lock;
}
