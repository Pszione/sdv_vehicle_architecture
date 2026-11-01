enum ActuatorState { idle, moving, stuck, fault }

enum ActuatorFaultType {
  none,
  mechanicalJam,        // Ex: Objeto bloqueando o teto solar/vidro
  overcurrent,          // Ex: Sobrecarga elétrica
  hardwareTimeout,      // Ex: Atuador não respondeu a tempo
}