import '../broker/signal_reader.dart';
import '../e2e/e2e_protected_signals.dart';
import '../e2e/signal_status.dart';
import '../profile/vehicle_groups.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';

/// ISO 2575 telltale colors: red = danger, amber = warning, green = function on, blue = high beam.
enum TelltaleColor { red, amber, green, blue }

enum TelltaleState { off, on, flashing }

/// Cluster telltales (warning lights). Their logic lives here, in the domain; the cluster
/// only draws them.
enum Telltale {
  leftTurn(TelltaleColor.green),
  highBeam(TelltaleColor.blue),
  cruiseActive(TelltaleColor.green),
  seatbelt(TelltaleColor.red),
  doorOpen(TelltaleColor.red),
  parkingBrake(TelltaleColor.red),
  lowVoltageBattery(TelltaleColor.red),
  escActive(TelltaleColor.amber),
  escOff(TelltaleColor.amber),
  laneDeparture(TelltaleColor.amber),
  tirePressure(TelltaleColor.amber),
  lowTractionBattery(TelltaleColor.amber),
  signalFault(TelltaleColor.amber),
  rightTurn(TelltaleColor.green);

  const Telltale(this.color);

  final TelltaleColor color;
}

/// Pure activation logic of every [Telltale]: which signals it reads and when it lights up.
abstract final class TelltaleLogic {
  /// The seatbelt reminder starts flashing above this speed (UN R16 escalation).
  static const seatbeltFlashSpeedKmh = 25.0;
  static const doorFlashSpeedKmh = 3.0;
  static const lowTractionBatteryPercent = 10.0;
  static const lowVoltageThreshold = 11.8;

  static final _tires = [
    Vss.Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.IsPressureLow,
    Vss.Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.IsPressureLow,
    Vss.Vehicle.Chassis.Axle.Row2.Wheel.Left.Tire.IsPressureLow,
    Vss.Vehicle.Chassis.Axle.Row2.Wheel.Right.Tire.IsPressureLow,
  ];

  static final _openings = [
    for (final door in VehicleGroups.doors) door.open,
    Vss.Vehicle.Body.Trunk.Rear.IsOpen,
    Vss.Vehicle.Body.Trunk.Front.IsOpen,
  ];

  static final _frontSeats = VehicleGroups.seats.take(2).toList();

  /// Signals whose value or status the telltale depends on.
  static Set<VssSignal<Object>> inputsOf(Telltale telltale) {
    final lights = Vss.Vehicle.Body.Lights;
    return switch (telltale) {
      Telltale.leftTurn => {lights.DirectionIndicator.Left.IsSignaling, lights.Hazard.IsSignaling},
      Telltale.rightTurn => {lights.DirectionIndicator.Right.IsSignaling, lights.Hazard.IsSignaling},
      Telltale.highBeam => {lights.Beam.High.IsOn},
      Telltale.cruiseActive => {Vss.Vehicle.ADAS.CruiseControl.IsActive},
      Telltale.seatbelt => {
        Vss.Vehicle.Speed,
        for (final seat in _frontSeats) ...[seat.occupancy, seat.belted],
      },
      Telltale.doorOpen => {Vss.Vehicle.Speed, ..._openings},
      Telltale.parkingBrake => {Vss.Vehicle.Chassis.ParkingBrake.IsEngaged},
      Telltale.lowVoltageBattery => {Vss.Vehicle.LowVoltageBattery.CurrentVoltage},
      Telltale.escActive => {Vss.Vehicle.ADAS.ESC.IsEngaged},
      Telltale.escOff => {Vss.Vehicle.ADAS.ESC.Mode},
      Telltale.laneDeparture => {Vss.Vehicle.ADAS.LaneDepartureDetection.IsWarning},
      Telltale.tirePressure => {..._tires},
      Telltale.lowTractionBattery => {Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge},
      Telltale.signalFault => {...E2eProtectedSignals.dataIds.keys},
    };
  }

  static TelltaleState evaluate(Telltale telltale, SignalReader signals) {
    bool isOn(VssSignal<bool> signal) => signals.read(signal) ?? false;
    TelltaleState on(bool condition) => condition ? TelltaleState.on : TelltaleState.off;
    TelltaleState flashing(bool condition) => condition ? TelltaleState.flashing : TelltaleState.off;
    final lights = Vss.Vehicle.Body.Lights;
    final speed = signals.read(Vss.Vehicle.Speed);

    switch (telltale) {
      case Telltale.leftTurn:
        return flashing(isOn(lights.DirectionIndicator.Left.IsSignaling) || isOn(lights.Hazard.IsSignaling));
      case Telltale.rightTurn:
        return flashing(isOn(lights.DirectionIndicator.Right.IsSignaling) || isOn(lights.Hazard.IsSignaling));
      case Telltale.highBeam:
        return on(isOn(lights.Beam.High.IsOn));
      case Telltale.cruiseActive:
        return on(isOn(Vss.Vehicle.ADAS.CruiseControl.IsActive));
      case Telltale.seatbelt:
        final isUnbelted = _frontSeats.any(
          (seat) => signals.read(seat.occupancy) == SeatOccupancy.occupied && !(signals.read(seat.belted) ?? true),
        );
        if (!isUnbelted) return TelltaleState.off;
        return (speed ?? 0) > seatbeltFlashSpeedKmh ? TelltaleState.flashing : TelltaleState.on;
      case Telltale.doorOpen:
        if (!_openings.any(isOn)) return TelltaleState.off;
        return (speed ?? 0) > doorFlashSpeedKmh ? TelltaleState.flashing : TelltaleState.on;
      case Telltale.parkingBrake:
        return on(isOn(Vss.Vehicle.Chassis.ParkingBrake.IsEngaged));
      case Telltale.lowVoltageBattery:
        final voltage = signals.read(Vss.Vehicle.LowVoltageBattery.CurrentVoltage);
        return on(voltage != null && voltage < lowVoltageThreshold);
      case Telltale.escActive:
        return flashing(isOn(Vss.Vehicle.ADAS.ESC.IsEngaged));
      case Telltale.escOff:
        return on(signals.read(Vss.Vehicle.ADAS.ESC.Mode) == EscMode.off);
      case Telltale.laneDeparture:
        return flashing(isOn(Vss.Vehicle.ADAS.LaneDepartureDetection.IsWarning));
      case Telltale.tirePressure:
        return on(_tires.any(isOn));
      case Telltale.lowTractionBattery:
        final soc = signals.read(Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge);
        return on(soc != null && soc < lowTractionBatteryPercent);
      case Telltale.signalFault:
        return on(
          E2eProtectedSignals.dataIds.keys.any(
            (signal) => const {SignalStatus.stale, SignalStatus.invalid}.contains(signals.statusOf(signal)),
          ),
        );
    }
  }
}
