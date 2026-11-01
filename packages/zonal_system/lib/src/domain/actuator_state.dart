enum ActuatorState { idle, moving, stuck, fault }

enum ActuatorFaultType {
  none,
  mechanicalJam, // E.g. an object blocking the sunroof/window
  overcurrent, // E.g. electrical overload
  hardwareTimeout, // E.g. the actuator did not respond in time
}
