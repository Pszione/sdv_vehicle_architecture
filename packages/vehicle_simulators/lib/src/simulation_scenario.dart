import 'package:vehicle_domain/vehicle_domain.dart';

import 'telemetry_simulator.dart';

/// One step of a scenario. Keeps the signal and value types together so the
/// broker/dispatcher receive correctly typed values.
sealed class SimulationStep {
  const SimulationStep();

  void runOn(TelemetrySimulator simulator);
}

/// A sensor reading (published to the broker).
final class SimulatedReading<T extends Object> extends SimulationStep {
  const SimulatedReading(this.signal, this.value);

  final VssSignal<T> signal;
  final T value;

  @override
  void runOn(TelemetrySimulator simulator) => simulator.report(signal, value);
}

/// An actuator request (goes through the dispatcher and its safety rules).
final class SimulatedCommand<T extends Object> extends SimulationStep {
  const SimulatedCommand(this.signal, this.value);

  final VssSignal<T> signal;
  final T value;

  @override
  void runOn(TelemetrySimulator simulator) => simulator.command(signal, value);
}

/// An actuator moved by hand (door handle): published as the zone ECU would report it, no rules.
final class SimulatedManualOperation<T extends Object> extends SimulationStep {
  const SimulatedManualOperation(this.signal, this.value);

  final VssSignal<T> signal;
  final T value;

  @override
  void runOn(TelemetrySimulator simulator) => simulator.operateManually(signal, value);
}

/// A pause, for steps that take time in a real car (e.g. the HV pre-charge before READY).
final class SimulatedWait extends SimulationStep {
  const SimulatedWait(this.duration);

  final Duration duration;

  @override
  void runOn(TelemetrySimulator simulator) {}
}

/// A named sequence of steps that puts the car in a known situation.
final class SimulationScenario {
  const SimulationScenario({required this.name, required this.description, required this.steps});

  final String name;
  final String description;
  final List<SimulationStep> steps;

  static final _speed = Vss.Vehicle.Speed;
  static final _gear = Vss.Vehicle.Powertrain.Transmission.SelectedGear;
  static final _brake = Vss.Vehicle.Chassis.Brake.PedalPosition;
  static final _battery = Vss.Vehicle.Powertrain.TractionBattery;
  static final _charging = _battery.Charging;
  static final _power = Vss.Vehicle.PowerMode.Request;
  static final _key = Vss.Vehicle.Body.Keyless.KeyLocation;
  static final _driverSeat = VehicleGroups.driverSeat;
  static final _driverDoor = VehicleGroups.driverDoor;

  /// Covers the HV pre-charge of the vehicle mode manager.
  static const _prechargeWait = SimulatedWait(Duration(milliseconds: 500));

  /// Driver seated and belted with the key, doors and trunk closed, unplugged, ignition ON.
  static List<SimulationStep> get _driverOnBoard => [
    SimulatedReading(_speed, 0.0),
    for (final door in VehicleGroups.doors) SimulatedManualOperation(door.open, false),
    SimulatedManualOperation(Vss.Vehicle.Body.Trunk.Rear.IsOpen, false),
    SimulatedReading(_charging.IsConnected, false),
    SimulatedReading(_charging.IsCharging, false),
    SimulatedReading(_driverSeat.occupancy, SeatOccupancy.occupied),
    SimulatedReading(_driverSeat.belted, true),
    SimulatedReading(_key, KeyLocation.inside),
    SimulatedCommand(_power, PowerModeRequest.on),
  ];

  /// Brake + START (READY), DRIVE engaged, brake released, then cruise at [speedKmh].
  static List<SimulationStep> _driveAt(double speedKmh) => [
    ..._driverOnBoard,
    SimulatedReading(_brake, 100),
    SimulatedCommand(_power, PowerModeRequest.ready),
    _prechargeWait,
    SimulatedCommand(_gear, Gear.drive),
    SimulatedReading(_brake, 0),
    SimulatedReading(Vss.Vehicle.Chassis.SteeringWheel.Angle, 0.0),
    SimulatedReading(_speed, speedKmh),
  ];

  /// Stops, parks and powers off with the driver still inside.
  static List<SimulationStep> get _parkAndPowerOff => [
    SimulatedReading(_speed, 0.0),
    SimulatedCommand(_gear, Gear.park),
    SimulatedCommand(_power, PowerModeRequest.off),
  ];

  /// Ready-made situations that exercise the safety rules and behaviors.
  static final presets = <SimulationScenario>[
    SimulationScenario(
      name: 'Parked & aligned',
      description: 'Driver on board, ignition ON, PARK, wheel straight, doors closed, unplugged, 80% SoC, 20 °C.',
      steps: [
        ..._driverOnBoard,
        SimulatedReading(Vss.Vehicle.Chassis.SteeringWheel.Angle, 0.0),
        SimulatedReading(_brake, 0),
        SimulatedReading(_battery.StateOfCharge, 80.0),
        SimulatedReading(Vss.Vehicle.Exterior.AirTemperature, 20.0),
        SimulatedReading(Vss.Vehicle.Body.Trailer.IsConnected, false),
        SimulatedReading(Vss.Vehicle.Body.IsCrashDetected, false),
        SimulatedCommand(_gear, Gear.park),
      ],
    ),
    SimulationScenario(
      name: 'Start (READY)',
      description: 'Driver on board presses the brake and START: HV pre-charge, then READY.',
      steps: [..._driverOnBoard, SimulatedReading(_brake, 100), SimulatedCommand(_power, PowerModeRequest.ready)],
    ),
    SimulationScenario(
      name: 'City driving',
      description: 'READY, DRIVE, 45 km/h. Auto-lock locks the doors.',
      steps: _driveAt(45.0),
    ),
    SimulationScenario(
      name: 'Highway',
      description: 'READY, DRIVE, 130 km/h. Auto-lock, and the suspension lowers itself.',
      steps: _driveAt(130.0),
    ),
    SimulationScenario(
      name: 'Tight trail turn',
      description: '10 km/h, wheel turned 35°.',
      steps: [SimulatedReading(_speed, 10.0), SimulatedReading(Vss.Vehicle.Chassis.SteeringWheel.Angle, 35.0)],
    ),
    SimulationScenario(
      name: 'Plugged in, low battery',
      description: 'PARK, charging cable connected and charging (power mode CHARGING), 10% SoC.',
      steps: [
        ..._parkAndPowerOff,
        SimulatedReading(_charging.IsConnected, true),
        SimulatedReading(_charging.IsCharging, true),
        SimulatedReading(_battery.StateOfCharge, 10.0),
      ],
    ),
    SimulationScenario(
      name: 'Driver door open',
      description: 'Stopped with the driver door open.',
      steps: [SimulatedReading(_speed, 0.0), SimulatedManualOperation(_driverDoor.open, true)],
    ),
    SimulationScenario(
      name: 'Driver leaves in DRIVE',
      description: 'Stopped in DRIVE, seatbelt off, door open. Auto-park engages PARK.',
      steps: [
        SimulatedReading(_speed, 0.0),
        SimulatedReading(_driverSeat.belted, false),
        SimulatedManualOperation(_driverDoor.open, true),
      ],
    ),
    SimulationScenario(
      name: 'Walk away',
      description: 'Park, get out with the key and walk away: auto power off, walk-away lock, sleep after 10 s.',
      steps: [
        ..._parkAndPowerOff,
        SimulatedReading(_driverSeat.belted, false),
        SimulatedManualOperation(_driverDoor.open, true),
        SimulatedReading(_driverSeat.occupancy, SeatOccupancy.empty),
        SimulatedManualOperation(_driverDoor.open, false),
        SimulatedReading(_key, KeyLocation.near),
        SimulatedReading(_key, KeyLocation.none),
      ],
    ),
    SimulationScenario(
      name: 'Ready for OTA',
      description: 'PARK, powered off, nobody inside, doors closed and locked, 80% SoC.',
      steps: [
        ..._parkAndPowerOff,
        SimulatedReading(_battery.StateOfCharge, 80.0),
        for (final seat in VehicleGroups.seats) SimulatedReading(seat.occupancy, SeatOccupancy.empty),
        // Opening a door ends the retained accessory power: the car is fully OFF.
        SimulatedManualOperation(_driverDoor.open, true),
        for (final door in VehicleGroups.doors) SimulatedManualOperation(door.open, false),
        for (final door in VehicleGroups.doors) SimulatedCommand(door.lock, true),
      ],
    ),
    SimulationScenario(
      name: 'Family on board',
      description: 'Every seat occupied.',
      steps: [for (final seat in VehicleGroups.seats) SimulatedReading(seat.occupancy, SeatOccupancy.occupied)],
    ),
    SimulationScenario(
      name: 'Weak 12 V battery',
      description: '12 V battery at 11.5 V: Sentry, Camp and Dog Mode refuse to start.',
      steps: [SimulatedReading(Vss.Vehicle.LowVoltageBattery.CurrentVoltage, 11.5)],
    ),
    SimulationScenario(
      name: 'Winter morning',
      description: 'Stopped, -5 °C outside and a cold cabin (2 °C).',
      steps: [
        SimulatedReading(_speed, 0.0),
        SimulatedReading(Vss.Vehicle.Exterior.AirTemperature, -5.0),
        SimulatedReading(Vss.Vehicle.Cabin.HVAC.AmbientAirTemperature, 2.0),
      ],
    ),
    SimulationScenario(
      name: 'Summer heat',
      description: 'Parked in the sun: 35 °C outside and a hot cabin (48 °C).',
      steps: [
        SimulatedReading(Vss.Vehicle.Exterior.AirTemperature, 35.0),
        SimulatedReading(Vss.Vehicle.Cabin.HVAC.AmbientAirTemperature, 48.0),
      ],
    ),
    SimulationScenario(
      name: 'Crash',
      description: 'Crash detected. The car unlocks every door and turns on the hazards.',
      steps: [SimulatedReading(Vss.Vehicle.Body.IsCrashDetected, true)],
    ),
  ];
}
