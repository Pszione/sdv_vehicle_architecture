import 'package:vehicle_domain/vehicle_domain.dart';

/// A simulated sensor reading. Keeps the signal and value types together so
/// the broker receives a correctly typed value.
final class SimulatedReading<T extends Object> {
  const SimulatedReading(this.signal, this.value);

  final VssSignal<T> signal;
  final T value;

  SignalWriteResult publishTo(VssBroker broker) => broker.publish(signal, value);
}

/// A named set of sensor readings that puts the vehicle in a known situation.
final class SimulationScenario {
  const SimulationScenario({required this.name, required this.description, required this.readings});

  final String name;
  final String description;
  final List<SimulatedReading<Object>> readings;

  /// Ready-made situations that exercise the safety rules.
  static final presets = <SimulationScenario>[
    SimulationScenario(
      name: 'Parked & aligned',
      description: '0 km/h, wheel straight, doors closed, unplugged, 80% SoC, 20 °C.',
      readings: [
        SimulatedReading(Vss.Vehicle.Speed, 0.0),
        SimulatedReading(Vss.Vehicle.Chassis.SteeringWheel.Angle, 0.0),
        SimulatedReading(Vss.Vehicle.Cabin.Door.Row1.Left.IsAjar, false),
        SimulatedReading(Vss.Vehicle.Cabin.Door.Row1.Right.IsAjar, false),
        SimulatedReading(Vss.Vehicle.Cabin.Door.Row2.Left.IsAjar, false),
        SimulatedReading(Vss.Vehicle.Cabin.Door.Row2.Right.IsAjar, false),
        SimulatedReading(Vss.Vehicle.Body.Trunk.IsAjar, false),
        SimulatedReading(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected, false),
        SimulatedReading(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge, 80.0),
        SimulatedReading(Vss.Vehicle.Exterior.AirTemperature, 20.0),
      ],
    ),
    SimulationScenario(
      name: 'City driving',
      description: '45 km/h, wheel straight.',
      readings: [
        SimulatedReading(Vss.Vehicle.Speed, 45.0),
        SimulatedReading(Vss.Vehicle.Chassis.SteeringWheel.Angle, 0.0),
      ],
    ),
    SimulationScenario(
      name: 'Highway',
      description: '130 km/h, wheel straight.',
      readings: [
        SimulatedReading(Vss.Vehicle.Speed, 130.0),
        SimulatedReading(Vss.Vehicle.Chassis.SteeringWheel.Angle, 0.0),
      ],
    ),
    SimulationScenario(
      name: 'Tight trail turn',
      description: '10 km/h, wheel turned 35°.',
      readings: [
        SimulatedReading(Vss.Vehicle.Speed, 10.0),
        SimulatedReading(Vss.Vehicle.Chassis.SteeringWheel.Angle, 35.0),
      ],
    ),
    SimulationScenario(
      name: 'Plugged in, low battery',
      description: 'Parked, charging cable connected, 10% SoC.',
      readings: [
        SimulatedReading(Vss.Vehicle.Speed, 0.0),
        SimulatedReading(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected, true),
        SimulatedReading(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge, 10.0),
      ],
    ),
    SimulationScenario(
      name: 'Driver door open',
      description: 'Parked with the front left door open.',
      readings: [
        SimulatedReading(Vss.Vehicle.Speed, 0.0),
        SimulatedReading(Vss.Vehicle.Cabin.Door.Row1.Left.IsAjar, true),
      ],
    ),
    SimulationScenario(
      name: 'Winter morning',
      description: 'Parked, -5 °C outside.',
      readings: [
        SimulatedReading(Vss.Vehicle.Speed, 0.0),
        SimulatedReading(Vss.Vehicle.Exterior.AirTemperature, -5.0),
      ],
    ),
  ];
}
