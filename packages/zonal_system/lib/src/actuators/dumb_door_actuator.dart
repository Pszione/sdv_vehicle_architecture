/// Atuador "burro" de trava de porta: aplica o sinal elétrico e reporta o estado físico.
class DumbDoorActuator {
  DumbDoorActuator(this.id);

  final String id;
  bool _isLocked = false;

  bool get isLocked => _isLocked;

  void applyLockSignal(bool lock) => _isLocked = lock;
}
