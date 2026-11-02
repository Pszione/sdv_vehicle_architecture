// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: vehicle.vss.json (COVESA VSS)
// ignore_for_file: type=lint

part of 'vss.dart';

/// Typed root of the VSS tree, e.g. `Vss.Vehicle.Cabin.Sunroof.Position`.
abstract final class Vss {
  static const Vehicle = _VssVehicle();
}

final class _VssVehicle {
  const _VssVehicle();

  VssSignal<double> get Speed => const VssSignal<double>('Vehicle.Speed');

  VssSignal<String> get DriveMode => const VssSignal<String>('Vehicle.DriveMode');

  _VssVehicleCabin get Cabin => const _VssVehicleCabin();

  _VssVehicleChassis get Chassis => const _VssVehicleChassis();

  _VssVehiclePowertrain get Powertrain => const _VssVehiclePowertrain();

  _VssVehicleBody get Body => const _VssVehicleBody();

  _VssVehicleMedia get Media => const _VssVehicleMedia();

  _VssVehicleADAS get ADAS => const _VssVehicleADAS();

  _VssVehicleSoftware get Software => const _VssVehicleSoftware();

  _VssVehicleExterior get Exterior => const _VssVehicleExterior();
}

final class _VssVehicleCabin {
  const _VssVehicleCabin();

  _VssVehicleCabinSunroof get Sunroof => const _VssVehicleCabinSunroof();

  _VssVehicleCabinDoor get Door => const _VssVehicleCabinDoor();

  _VssVehicleCabinHVAC get HVAC => const _VssVehicleCabinHVAC();

  _VssVehicleCabinAmbientLighting get AmbientLighting => const _VssVehicleCabinAmbientLighting();

  _VssVehicleCabinHeadUpDisplay get HeadUpDisplay => const _VssVehicleCabinHeadUpDisplay();

  _VssVehicleCabinSentry get Sentry => const _VssVehicleCabinSentry();

  _VssVehicleCabinValetMode get ValetMode => const _VssVehicleCabinValetMode();

  _VssVehicleCabinGlovebox get Glovebox => const _VssVehicleCabinGlovebox();

  _VssVehicleCabinConvertibleTop get ConvertibleTop => const _VssVehicleCabinConvertibleTop();

  _VssVehicleCabinSeat get Seat => const _VssVehicleCabinSeat();
}

final class _VssVehicleCabinSunroof {
  const _VssVehicleCabinSunroof();

  /// 0.0 = closed, 1.0 = fully open.
  VssSignal<double> get Position => const VssSignal<double>('Vehicle.Cabin.Sunroof.Position');

  VssSignal<bool> get IsFaulted => const VssSignal<bool>('Vehicle.Cabin.Sunroof.IsFaulted');

  VssSignal<double> get ElectrochromicOpacity => const VssSignal<double>('Vehicle.Cabin.Sunroof.ElectrochromicOpacity');
}

final class _VssVehicleCabinDoor {
  const _VssVehicleCabinDoor();

  _VssVehicleCabinDoorRow1 get Row1 => const _VssVehicleCabinDoorRow1();

  _VssVehicleCabinDoorRow2 get Row2 => const _VssVehicleCabinDoorRow2();
}

final class _VssVehicleCabinDoorRow1 {
  const _VssVehicleCabinDoorRow1();

  _VssVehicleCabinDoorRow1DriverSide get DriverSide => const _VssVehicleCabinDoorRow1DriverSide();

  _VssVehicleCabinDoorRow1PassengerSide get PassengerSide => const _VssVehicleCabinDoorRow1PassengerSide();
}

final class _VssVehicleCabinDoorRow1DriverSide {
  const _VssVehicleCabinDoorRow1DriverSide();

  /// Is the door open. Modeled as a sensor (manually operated doors); actuator in COVESA VSS.
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.DriverSide.IsOpen');

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.DriverSide.IsLocked');

  /// Custom signal (not in COVESA VSS).
  VssSignal<String> get SoftCloseState => const VssSignal<String>('Vehicle.Cabin.Door.Row1.DriverSide.SoftCloseState');
}

final class _VssVehicleCabinDoorRow1PassengerSide {
  const _VssVehicleCabinDoorRow1PassengerSide();

  /// Is the door open. Modeled as a sensor (manually operated doors); actuator in COVESA VSS.
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.PassengerSide.IsOpen');

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.PassengerSide.IsLocked');

  /// Custom signal (not in COVESA VSS).
  VssSignal<String> get SoftCloseState =>
      const VssSignal<String>('Vehicle.Cabin.Door.Row1.PassengerSide.SoftCloseState');
}

final class _VssVehicleCabinDoorRow2 {
  const _VssVehicleCabinDoorRow2();

  _VssVehicleCabinDoorRow2DriverSide get DriverSide => const _VssVehicleCabinDoorRow2DriverSide();

  _VssVehicleCabinDoorRow2PassengerSide get PassengerSide => const _VssVehicleCabinDoorRow2PassengerSide();
}

final class _VssVehicleCabinDoorRow2DriverSide {
  const _VssVehicleCabinDoorRow2DriverSide();

  /// Is the door open. Modeled as a sensor (manually operated doors); actuator in COVESA VSS.
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.DriverSide.IsOpen');

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.DriverSide.IsLocked');

  _VssVehicleCabinDoorRow2DriverSideShade get Shade => const _VssVehicleCabinDoorRow2DriverSideShade();
}

final class _VssVehicleCabinDoorRow2DriverSideShade {
  const _VssVehicleCabinDoorRow2DriverSideShade();

  /// Side window shade. 0 = retracted, 100 = deployed.
  VssSignal<int> get Position => const VssSignal<int>('Vehicle.Cabin.Door.Row2.DriverSide.Shade.Position');
}

final class _VssVehicleCabinDoorRow2PassengerSide {
  const _VssVehicleCabinDoorRow2PassengerSide();

  /// Is the door open. Modeled as a sensor (manually operated doors); actuator in COVESA VSS.
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.PassengerSide.IsOpen');

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.PassengerSide.IsLocked');

  _VssVehicleCabinDoorRow2PassengerSideShade get Shade => const _VssVehicleCabinDoorRow2PassengerSideShade();
}

final class _VssVehicleCabinDoorRow2PassengerSideShade {
  const _VssVehicleCabinDoorRow2PassengerSideShade();

  /// Side window shade. 0 = retracted, 100 = deployed.
  VssSignal<int> get Position => const VssSignal<int>('Vehicle.Cabin.Door.Row2.PassengerSide.Shade.Position');
}

final class _VssVehicleCabinHVAC {
  const _VssVehicleCabinHVAC();

  _VssVehicleCabinHVACAirConditioning get AirConditioning => const _VssVehicleCabinHVACAirConditioning();

  VssSignal<int> get AirQuality => const VssSignal<int>('Vehicle.Cabin.HVAC.AirQuality');

  VssSignal<bool> get IonizerIsEnabled => const VssSignal<bool>('Vehicle.Cabin.HVAC.IonizerIsEnabled');

  _VssVehicleCabinHVACFragrance get Fragrance => const _VssVehicleCabinHVACFragrance();

  _VssVehicleCabinHVACDogMode get DogMode => const _VssVehicleCabinHVACDogMode();

  _VssVehicleCabinHVACCampMode get CampMode => const _VssVehicleCabinHVACCampMode();

  _VssVehicleCabinHVACStation get Station => const _VssVehicleCabinHVACStation();

  VssSignal<bool> get IsAirConditioningActive => const VssSignal<bool>('Vehicle.Cabin.HVAC.IsAirConditioningActive');

  VssSignal<bool> get IsRecirculationActive => const VssSignal<bool>('Vehicle.Cabin.HVAC.IsRecirculationActive');

  VssSignal<bool> get IsFrontDefrosterActive => const VssSignal<bool>('Vehicle.Cabin.HVAC.IsFrontDefrosterActive');

  VssSignal<bool> get IsRearDefrosterActive => const VssSignal<bool>('Vehicle.Cabin.HVAC.IsRearDefrosterActive');

  /// Cabin (ambient) air temperature.
  VssSignal<double> get AmbientAirTemperature => const VssSignal<double>('Vehicle.Cabin.HVAC.AmbientAirTemperature');

  /// Automatic climate: the HVAC ECU drives fan speed. Custom signal (not in COVESA VSS).
  VssSignal<bool> get IsAutoActive => const VssSignal<bool>('Vehicle.Cabin.HVAC.IsAutoActive');

  /// Passenger and rear zones follow the driver temperature. Custom signal (not in COVESA VSS).
  VssSignal<bool> get IsSyncActive => const VssSignal<bool>('Vehicle.Cabin.HVAC.IsSyncActive');

  /// Rear passengers cannot change the rear zone. Custom signal (not in COVESA VSS).
  VssSignal<bool> get IsRearControlLocked => const VssSignal<bool>('Vehicle.Cabin.HVAC.IsRearControlLocked');
}

final class _VssVehicleCabinHVACAirConditioning {
  const _VssVehicleCabinHVACAirConditioning();

  VssSignal<bool> get StationaryPreconditioning =>
      const VssSignal<bool>('Vehicle.Cabin.HVAC.AirConditioning.StationaryPreconditioning');
}

final class _VssVehicleCabinHVACFragrance {
  const _VssVehicleCabinHVACFragrance();

  VssSignal<int> get ActiveCartridge => const VssSignal<int>('Vehicle.Cabin.HVAC.Fragrance.ActiveCartridge');

  VssSignal<int> get Intensity => const VssSignal<int>('Vehicle.Cabin.HVAC.Fragrance.Intensity');
}

final class _VssVehicleCabinHVACDogMode {
  const _VssVehicleCabinHVACDogMode();

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.Cabin.HVAC.DogMode.IsEnabled');

  VssSignal<double> get TargetTemperature => const VssSignal<double>('Vehicle.Cabin.HVAC.DogMode.TargetTemperature');
}

final class _VssVehicleCabinHVACCampMode {
  const _VssVehicleCabinHVACCampMode();

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.Cabin.HVAC.CampMode.IsEnabled');
}

final class _VssVehicleCabinHVACStation {
  const _VssVehicleCabinHVACStation();

  _VssVehicleCabinHVACStationRow1 get Row1 => const _VssVehicleCabinHVACStationRow1();

  _VssVehicleCabinHVACStationRow2 get Row2 => const _VssVehicleCabinHVACStationRow2();
}

final class _VssVehicleCabinHVACStationRow1 {
  const _VssVehicleCabinHVACStationRow1();

  _VssVehicleCabinHVACStationRow1Driver get Driver => const _VssVehicleCabinHVACStationRow1Driver();

  _VssVehicleCabinHVACStationRow1Passenger get Passenger => const _VssVehicleCabinHVACStationRow1Passenger();
}

final class _VssVehicleCabinHVACStationRow1Driver {
  const _VssVehicleCabinHVACStationRow1Driver();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Station.Row1.Driver.Temperature');

  /// Fan speed. 0 = off, 100 = max.
  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Station.Row1.Driver.FanSpeed');

  VssSignal<String> get AirDistribution =>
      const VssSignal<String>('Vehicle.Cabin.HVAC.Station.Row1.Driver.AirDistribution');
}

final class _VssVehicleCabinHVACStationRow1Passenger {
  const _VssVehicleCabinHVACStationRow1Passenger();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Station.Row1.Passenger.Temperature');

  /// Fan speed. 0 = off, 100 = max.
  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Station.Row1.Passenger.FanSpeed');

  VssSignal<String> get AirDistribution =>
      const VssSignal<String>('Vehicle.Cabin.HVAC.Station.Row1.Passenger.AirDistribution');
}

final class _VssVehicleCabinHVACStationRow2 {
  const _VssVehicleCabinHVACStationRow2();

  _VssVehicleCabinHVACStationRow2Driver get Driver => const _VssVehicleCabinHVACStationRow2Driver();

  _VssVehicleCabinHVACStationRow2Passenger get Passenger => const _VssVehicleCabinHVACStationRow2Passenger();
}

final class _VssVehicleCabinHVACStationRow2Driver {
  const _VssVehicleCabinHVACStationRow2Driver();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Station.Row2.Driver.Temperature');

  /// Fan speed. 0 = off, 100 = max.
  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Station.Row2.Driver.FanSpeed');

  VssSignal<String> get AirDistribution =>
      const VssSignal<String>('Vehicle.Cabin.HVAC.Station.Row2.Driver.AirDistribution');
}

final class _VssVehicleCabinHVACStationRow2Passenger {
  const _VssVehicleCabinHVACStationRow2Passenger();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Station.Row2.Passenger.Temperature');

  /// Fan speed. 0 = off, 100 = max.
  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Station.Row2.Passenger.FanSpeed');

  VssSignal<String> get AirDistribution =>
      const VssSignal<String>('Vehicle.Cabin.HVAC.Station.Row2.Passenger.AirDistribution');
}

final class _VssVehicleCabinAmbientLighting {
  const _VssVehicleCabinAmbientLighting();

  VssSignal<String> get ColorHex => const VssSignal<String>('Vehicle.Cabin.AmbientLighting.ColorHex');

  VssSignal<double> get Brightness => const VssSignal<double>('Vehicle.Cabin.AmbientLighting.Brightness');

  VssSignal<String> get AnimationMode => const VssSignal<String>('Vehicle.Cabin.AmbientLighting.AnimationMode');
}

final class _VssVehicleCabinHeadUpDisplay {
  const _VssVehicleCabinHeadUpDisplay();

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.Cabin.HeadUpDisplay.IsEnabled');

  VssSignal<int> get Height => const VssSignal<int>('Vehicle.Cabin.HeadUpDisplay.Height');

  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.Cabin.HeadUpDisplay.Mode');
}

final class _VssVehicleCabinSentry {
  const _VssVehicleCabinSentry();

  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.Cabin.Sentry.Mode');

  VssSignal<int> get ThreatLevel => const VssSignal<int>('Vehicle.Cabin.Sentry.ThreatLevel');
}

final class _VssVehicleCabinValetMode {
  const _VssVehicleCabinValetMode();

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.Cabin.ValetMode.IsEnabled');
}

final class _VssVehicleCabinGlovebox {
  const _VssVehicleCabinGlovebox();

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Glovebox.IsLocked');
}

final class _VssVehicleCabinConvertibleTop {
  const _VssVehicleCabinConvertibleTop();

  /// 0.0 = closed, 1.0 = fully open.
  VssSignal<double> get Position => const VssSignal<double>('Vehicle.Cabin.ConvertibleTop.Position');
}

final class _VssVehicleCabinSeat {
  const _VssVehicleCabinSeat();

  _VssVehicleCabinSeatRow1 get Row1 => const _VssVehicleCabinSeatRow1();

  _VssVehicleCabinSeatRow2 get Row2 => const _VssVehicleCabinSeatRow2();
}

final class _VssVehicleCabinSeatRow1 {
  const _VssVehicleCabinSeatRow1();

  _VssVehicleCabinSeatRow1DriverSide get DriverSide => const _VssVehicleCabinSeatRow1DriverSide();

  _VssVehicleCabinSeatRow1PassengerSide get PassengerSide => const _VssVehicleCabinSeatRow1PassengerSide();
}

final class _VssVehicleCabinSeatRow1DriverSide {
  const _VssVehicleCabinSeatRow1DriverSide();

  VssSignal<String> get OccupancyStatus =>
      const VssSignal<String>('Vehicle.Cabin.Seat.Row1.DriverSide.OccupancyStatus');

  VssSignal<bool> get IsBelted => const VssSignal<bool>('Vehicle.Cabin.Seat.Row1.DriverSide.IsBelted');

  /// -100 = maximum cooling (ventilation), 0 = off, 100 = maximum heating.
  VssSignal<int> get HeatingCooling => const VssSignal<int>('Vehicle.Cabin.Seat.Row1.DriverSide.HeatingCooling');

  _VssVehicleCabinSeatRow1DriverSideMassage get Massage => const _VssVehicleCabinSeatRow1DriverSideMassage();

  _VssVehicleCabinSeatRow1DriverSideBackrest get Backrest => const _VssVehicleCabinSeatRow1DriverSideBackrest();
}

final class _VssVehicleCabinSeatRow1DriverSideMassage {
  const _VssVehicleCabinSeatRow1DriverSideMassage();

  /// Massage level. 0 = off.
  VssSignal<int> get Level => const VssSignal<int>('Vehicle.Cabin.Seat.Row1.DriverSide.Massage.Level');

  VssSignal<String> get TypeActive => const VssSignal<String>('Vehicle.Cabin.Seat.Row1.DriverSide.Massage.TypeActive');
}

final class _VssVehicleCabinSeatRow1DriverSideBackrest {
  const _VssVehicleCabinSeatRow1DriverSideBackrest();

  VssSignal<double> get SideBolsterSupport =>
      const VssSignal<double>('Vehicle.Cabin.Seat.Row1.DriverSide.Backrest.SideBolsterSupport');
}

final class _VssVehicleCabinSeatRow1PassengerSide {
  const _VssVehicleCabinSeatRow1PassengerSide();

  VssSignal<String> get OccupancyStatus =>
      const VssSignal<String>('Vehicle.Cabin.Seat.Row1.PassengerSide.OccupancyStatus');

  VssSignal<bool> get IsBelted => const VssSignal<bool>('Vehicle.Cabin.Seat.Row1.PassengerSide.IsBelted');

  /// -100 = maximum cooling (ventilation), 0 = off, 100 = maximum heating.
  VssSignal<int> get HeatingCooling => const VssSignal<int>('Vehicle.Cabin.Seat.Row1.PassengerSide.HeatingCooling');

  _VssVehicleCabinSeatRow1PassengerSideMassage get Massage => const _VssVehicleCabinSeatRow1PassengerSideMassage();
}

final class _VssVehicleCabinSeatRow1PassengerSideMassage {
  const _VssVehicleCabinSeatRow1PassengerSideMassage();

  /// Massage level. 0 = off.
  VssSignal<int> get Level => const VssSignal<int>('Vehicle.Cabin.Seat.Row1.PassengerSide.Massage.Level');

  VssSignal<String> get TypeActive =>
      const VssSignal<String>('Vehicle.Cabin.Seat.Row1.PassengerSide.Massage.TypeActive');
}

final class _VssVehicleCabinSeatRow2 {
  const _VssVehicleCabinSeatRow2();

  _VssVehicleCabinSeatRow2DriverSide get DriverSide => const _VssVehicleCabinSeatRow2DriverSide();

  _VssVehicleCabinSeatRow2PassengerSide get PassengerSide => const _VssVehicleCabinSeatRow2PassengerSide();
}

final class _VssVehicleCabinSeatRow2DriverSide {
  const _VssVehicleCabinSeatRow2DriverSide();

  VssSignal<String> get OccupancyStatus =>
      const VssSignal<String>('Vehicle.Cabin.Seat.Row2.DriverSide.OccupancyStatus');

  VssSignal<bool> get IsBelted => const VssSignal<bool>('Vehicle.Cabin.Seat.Row2.DriverSide.IsBelted');

  /// -100 = maximum cooling (ventilation), 0 = off, 100 = maximum heating.
  VssSignal<int> get HeatingCooling => const VssSignal<int>('Vehicle.Cabin.Seat.Row2.DriverSide.HeatingCooling');

  _VssVehicleCabinSeatRow2DriverSideMassage get Massage => const _VssVehicleCabinSeatRow2DriverSideMassage();

  _VssVehicleCabinSeatRow2DriverSideBackrest get Backrest => const _VssVehicleCabinSeatRow2DriverSideBackrest();
}

final class _VssVehicleCabinSeatRow2DriverSideMassage {
  const _VssVehicleCabinSeatRow2DriverSideMassage();

  /// Massage level. 0 = off.
  VssSignal<int> get Level => const VssSignal<int>('Vehicle.Cabin.Seat.Row2.DriverSide.Massage.Level');

  VssSignal<String> get TypeActive => const VssSignal<String>('Vehicle.Cabin.Seat.Row2.DriverSide.Massage.TypeActive');
}

final class _VssVehicleCabinSeatRow2DriverSideBackrest {
  const _VssVehicleCabinSeatRow2DriverSideBackrest();

  VssSignal<double> get Recline => const VssSignal<double>('Vehicle.Cabin.Seat.Row2.DriverSide.Backrest.Recline');
}

final class _VssVehicleCabinSeatRow2PassengerSide {
  const _VssVehicleCabinSeatRow2PassengerSide();

  VssSignal<String> get OccupancyStatus =>
      const VssSignal<String>('Vehicle.Cabin.Seat.Row2.PassengerSide.OccupancyStatus');

  VssSignal<bool> get IsBelted => const VssSignal<bool>('Vehicle.Cabin.Seat.Row2.PassengerSide.IsBelted');

  /// -100 = maximum cooling (ventilation), 0 = off, 100 = maximum heating.
  VssSignal<int> get HeatingCooling => const VssSignal<int>('Vehicle.Cabin.Seat.Row2.PassengerSide.HeatingCooling');

  _VssVehicleCabinSeatRow2PassengerSideMassage get Massage => const _VssVehicleCabinSeatRow2PassengerSideMassage();

  _VssVehicleCabinSeatRow2PassengerSideBackrest get Backrest => const _VssVehicleCabinSeatRow2PassengerSideBackrest();
}

final class _VssVehicleCabinSeatRow2PassengerSideMassage {
  const _VssVehicleCabinSeatRow2PassengerSideMassage();

  /// Massage level. 0 = off.
  VssSignal<int> get Level => const VssSignal<int>('Vehicle.Cabin.Seat.Row2.PassengerSide.Massage.Level');

  VssSignal<String> get TypeActive =>
      const VssSignal<String>('Vehicle.Cabin.Seat.Row2.PassengerSide.Massage.TypeActive');
}

final class _VssVehicleCabinSeatRow2PassengerSideBackrest {
  const _VssVehicleCabinSeatRow2PassengerSideBackrest();

  VssSignal<double> get Recline => const VssSignal<double>('Vehicle.Cabin.Seat.Row2.PassengerSide.Backrest.Recline');
}

final class _VssVehicleChassis {
  const _VssVehicleChassis();

  _VssVehicleChassisSteeringWheel get SteeringWheel => const _VssVehicleChassisSteeringWheel();

  _VssVehicleChassisRearAxleSteering get RearAxleSteering => const _VssVehicleChassisRearAxleSteering();

  _VssVehicleChassisSuspension get Suspension => const _VssVehicleChassisSuspension();

  _VssVehicleChassisBrake get Brake => const _VssVehicleChassisBrake();

  _VssVehicleChassisAxle get Axle => const _VssVehicleChassisAxle();
}

final class _VssVehicleChassisSteeringWheel {
  const _VssVehicleChassisSteeringWheel();

  VssSignal<double> get Angle => const VssSignal<double>('Vehicle.Chassis.SteeringWheel.Angle');

  /// -100 = maximum cooling, 0 = off, 100 = maximum heating.
  VssSignal<int> get HeatingCooling => const VssSignal<int>('Vehicle.Chassis.SteeringWheel.HeatingCooling');
}

final class _VssVehicleChassisRearAxleSteering {
  const _VssVehicleChassisRearAxleSteering();

  VssSignal<double> get Angle => const VssSignal<double>('Vehicle.Chassis.RearAxleSteering.Angle');
}

final class _VssVehicleChassisSuspension {
  const _VssVehicleChassisSuspension();

  VssSignal<String> get Height => const VssSignal<String>('Vehicle.Chassis.Suspension.Height');

  VssSignal<String> get DampingMode => const VssSignal<String>('Vehicle.Chassis.Suspension.DampingMode');

  _VssVehicleChassisSuspensionAutoLeveling get AutoLeveling => const _VssVehicleChassisSuspensionAutoLeveling();
}

final class _VssVehicleChassisSuspensionAutoLeveling {
  const _VssVehicleChassisSuspensionAutoLeveling();

  VssSignal<String> get Status => const VssSignal<String>('Vehicle.Chassis.Suspension.AutoLeveling.Status');
}

final class _VssVehicleChassisBrake {
  const _VssVehicleChassisBrake();

  VssSignal<String> get RegenMode => const VssSignal<String>('Vehicle.Chassis.Brake.RegenMode');

  /// Brake pedal travel. 0 = released, 100 = fully pressed.
  VssSignal<int> get PedalPosition => const VssSignal<int>('Vehicle.Chassis.Brake.PedalPosition');
}

final class _VssVehicleChassisAxle {
  const _VssVehicleChassisAxle();

  _VssVehicleChassisAxleRow2 get Row2 => const _VssVehicleChassisAxleRow2();
}

final class _VssVehicleChassisAxleRow2 {
  const _VssVehicleChassisAxleRow2();

  _VssVehicleChassisAxleRow2Differential get Differential => const _VssVehicleChassisAxleRow2Differential();
}

final class _VssVehicleChassisAxleRow2Differential {
  const _VssVehicleChassisAxleRow2Differential();

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Chassis.Axle.Row2.Differential.IsLocked');
}

final class _VssVehiclePowertrain {
  const _VssVehiclePowertrain();

  _VssVehiclePowertrainTorqueSplit get TorqueSplit => const _VssVehiclePowertrainTorqueSplit();

  _VssVehiclePowertrainTractionBattery get TractionBattery => const _VssVehiclePowertrainTractionBattery();

  _VssVehiclePowertrainV2L get V2L => const _VssVehiclePowertrainV2L();

  _VssVehiclePowertrainCombustionEngine get CombustionEngine => const _VssVehiclePowertrainCombustionEngine();

  _VssVehiclePowertrainTransmission get Transmission => const _VssVehiclePowertrainTransmission();
}

final class _VssVehiclePowertrainTorqueSplit {
  const _VssVehiclePowertrainTorqueSplit();

  VssSignal<double> get RearPercent => const VssSignal<double>('Vehicle.Powertrain.TorqueSplit.RearPercent');
}

final class _VssVehiclePowertrainTractionBattery {
  const _VssVehiclePowertrainTractionBattery();

  VssSignal<double> get StateOfCharge => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.StateOfCharge');

  VssSignal<double> get Power => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.Power');

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.Temperature');

  _VssVehiclePowertrainTractionBatteryPreconditioning get Preconditioning =>
      const _VssVehiclePowertrainTractionBatteryPreconditioning();

  _VssVehiclePowertrainTractionBatteryCharging get Charging => const _VssVehiclePowertrainTractionBatteryCharging();
}

final class _VssVehiclePowertrainTractionBatteryPreconditioning {
  const _VssVehiclePowertrainTractionBatteryPreconditioning();

  VssSignal<String> get Status => const VssSignal<String>('Vehicle.Powertrain.TractionBattery.Preconditioning.Status');

  VssSignal<bool> get IsEnabled =>
      const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled');
}

final class _VssVehiclePowertrainTractionBatteryCharging {
  const _VssVehiclePowertrainTractionBatteryCharging();

  VssSignal<bool> get IsConnected => const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.Charging.IsConnected');

  VssSignal<bool> get IsCharging => const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.Charging.IsCharging');

  VssSignal<double> get ChargePower =>
      const VssSignal<double>('Vehicle.Powertrain.TractionBattery.Charging.ChargePower');

  VssSignal<double> get TargetSoC => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.Charging.TargetSoC');

  VssSignal<String> get ChargePortFlap =>
      const VssSignal<String>('Vehicle.Powertrain.TractionBattery.Charging.ChargePortFlap');

  VssSignal<bool> get IsChargingCableLocked =>
      const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.Charging.IsChargingCableLocked');
}

final class _VssVehiclePowertrainV2L {
  const _VssVehiclePowertrainV2L();

  VssSignal<bool> get IsExportingPower => const VssSignal<bool>('Vehicle.Powertrain.V2L.IsExportingPower');
}

final class _VssVehiclePowertrainCombustionEngine {
  const _VssVehiclePowertrainCombustionEngine();

  VssSignal<double> get Speed => const VssSignal<double>('Vehicle.Powertrain.CombustionEngine.Speed');
}

final class _VssVehiclePowertrainTransmission {
  const _VssVehiclePowertrainTransmission();

  VssSignal<String> get SelectedGear => const VssSignal<String>('Vehicle.Powertrain.Transmission.SelectedGear');
}

final class _VssVehicleBody {
  const _VssVehicleBody();

  _VssVehicleBodyTrunk get Trunk => const _VssVehicleBodyTrunk();

  _VssVehicleBodyTrailer get Trailer => const _VssVehicleBodyTrailer();

  _VssVehicleBodyLights get Lights => const _VssVehicleBodyLights();

  VssSignal<bool> get IsCrashDetected => const VssSignal<bool>('Vehicle.Body.IsCrashDetected');
}

final class _VssVehicleBodyTrunk {
  const _VssVehicleBodyTrunk();

  VssSignal<bool> get IsAjar => const VssSignal<bool>('Vehicle.Body.Trunk.IsAjar');

  /// Power tailgate angle. 0 = closed.
  VssSignal<double> get PowerOpeningAngle => const VssSignal<double>('Vehicle.Body.Trunk.PowerOpeningAngle');

  _VssVehicleBodyTrunkFront get Front => const _VssVehicleBodyTrunkFront();
}

final class _VssVehicleBodyTrunkFront {
  const _VssVehicleBodyTrunkFront();

  /// Front trunk (frunk).
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Body.Trunk.Front.IsOpen');
}

final class _VssVehicleBodyTrailer {
  const _VssVehicleBodyTrailer();

  VssSignal<bool> get IsConnected => const VssSignal<bool>('Vehicle.Body.Trailer.IsConnected');

  VssSignal<double> get BrakeGain => const VssSignal<double>('Vehicle.Body.Trailer.BrakeGain');
}

final class _VssVehicleBodyLights {
  const _VssVehicleBodyLights();

  VssSignal<bool> get IsLeftIndicatorOn => const VssSignal<bool>('Vehicle.Body.Lights.IsLeftIndicatorOn');

  VssSignal<bool> get IsRightIndicatorOn => const VssSignal<bool>('Vehicle.Body.Lights.IsRightIndicatorOn');

  VssSignal<bool> get IsHazardOn => const VssSignal<bool>('Vehicle.Body.Lights.IsHazardOn');

  VssSignal<String> get MatrixBeamMode => const VssSignal<String>('Vehicle.Body.Lights.MatrixBeamMode');
}

final class _VssVehicleMedia {
  const _VssVehicleMedia();

  VssSignal<String> get ActiveSoundDesign => const VssSignal<String>('Vehicle.Media.ActiveSoundDesign');

  VssSignal<bool> get ActiveNoiseCancellation => const VssSignal<bool>('Vehicle.Media.ActiveNoiseCancellation');

  VssSignal<String> get SoundZoneBalance => const VssSignal<String>('Vehicle.Media.SoundZoneBalance');
}

final class _VssVehicleADAS {
  const _VssVehicleADAS();

  _VssVehicleADASACC get ACC => const _VssVehicleADASACC();

  _VssVehicleADASObstacleDetection get ObstacleDetection => const _VssVehicleADASObstacleDetection();

  _VssVehicleADASLaneKeepingAssist get LaneKeepingAssist => const _VssVehicleADASLaneKeepingAssist();

  _VssVehicleADASHillDescentControl get HillDescentControl => const _VssVehicleADASHillDescentControl();

  _VssVehicleADASESC get ESC => const _VssVehicleADASESC();

  _VssVehicleADASSpeedLimiter get SpeedLimiter => const _VssVehicleADASSpeedLimiter();
}

final class _VssVehicleADASACC {
  const _VssVehicleADASACC();

  VssSignal<bool> get IsEngaged => const VssSignal<bool>('Vehicle.ADAS.ACC.IsEngaged');

  VssSignal<double> get SetSpeed => const VssSignal<double>('Vehicle.ADAS.ACC.SetSpeed');
}

final class _VssVehicleADASObstacleDetection {
  const _VssVehicleADASObstacleDetection();

  /// Lead vehicle object serialized as JSON.
  VssSignal<String> get LeadVehicle => const VssSignal<String>('Vehicle.ADAS.ObstacleDetection.LeadVehicle');
}

final class _VssVehicleADASLaneKeepingAssist {
  const _VssVehicleADASLaneKeepingAssist();

  VssSignal<String> get Status => const VssSignal<String>('Vehicle.ADAS.LaneKeepingAssist.Status');

  VssSignal<double> get LeftLaneOffsetMeters =>
      const VssSignal<double>('Vehicle.ADAS.LaneKeepingAssist.LeftLaneOffsetMeters');

  VssSignal<double> get RightLaneOffsetMeters =>
      const VssSignal<double>('Vehicle.ADAS.LaneKeepingAssist.RightLaneOffsetMeters');

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.ADAS.LaneKeepingAssist.IsEnabled');
}

final class _VssVehicleADASHillDescentControl {
  const _VssVehicleADASHillDescentControl();

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.ADAS.HillDescentControl.IsEnabled');
}

final class _VssVehicleADASESC {
  const _VssVehicleADASESC();

  /// Electronic stability control mode.
  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.ADAS.ESC.Mode');
}

final class _VssVehicleADASSpeedLimiter {
  const _VssVehicleADASSpeedLimiter();

  VssSignal<double> get SetSpeed => const VssSignal<double>('Vehicle.ADAS.SpeedLimiter.SetSpeed');
}

final class _VssVehicleSoftware {
  const _VssVehicleSoftware();

  _VssVehicleSoftwareOTA get OTA => const _VssVehicleSoftwareOTA();
}

final class _VssVehicleSoftwareOTA {
  const _VssVehicleSoftwareOTA();

  VssSignal<String> get Status => const VssSignal<String>('Vehicle.Software.OTA.Status');

  /// Requests/reports an OTA installation.
  VssSignal<bool> get IsInstalling => const VssSignal<bool>('Vehicle.Software.OTA.IsInstalling');
}

final class _VssVehicleExterior {
  const _VssVehicleExterior();

  VssSignal<double> get AirTemperature => const VssSignal<double>('Vehicle.Exterior.AirTemperature');
}

/// Metadata of every signal in the spec, keyed by VSS path.
const Map<String, VssSignalMeta> vssCatalog = {
  'Vehicle.Speed': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'km/h',
    min: 0,
    max: 300,
    defaultValue: 0.0,
  ),
  'Vehicle.DriveMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.Sunroof.Position': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    min: 0,
    max: 1,
    defaultValue: 0.0,
  ),
  'Vehicle.Cabin.Sunroof.IsFaulted': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Sunroof.ElectrochromicOpacity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.Door.Row1.DriverSide.IsOpen': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row1.DriverSide.IsLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row1.DriverSide.SoftCloseState': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Cabin.Door.Row1.PassengerSide.IsOpen': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row1.PassengerSide.IsLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row1.PassengerSide.SoftCloseState': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Cabin.Door.Row2.DriverSide.IsOpen': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row2.DriverSide.IsLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row2.DriverSide.Shade.Position': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Door.Row2.PassengerSide.IsOpen': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row2.PassengerSide.IsLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Door.Row2.PassengerSide.Shade.Position': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.HVAC.AirConditioning.StationaryPreconditioning': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
  ),
  'Vehicle.Cabin.HVAC.AirQuality': VssSignalMeta(type: VssNodeType.sensor, datatype: 'uint8'),
  'Vehicle.Cabin.HVAC.IonizerIsEnabled': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.HVAC.Fragrance.ActiveCartridge': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Cabin.HVAC.Fragrance.Intensity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Cabin.HVAC.DogMode.IsEnabled': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.DogMode.TargetTemperature': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.HVAC.CampMode.IsEnabled': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.Station.Row1.Driver.Temperature': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'celsius',
    min: 16,
    max: 30,
    defaultValue: 21.0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row1.Driver.FanSpeed': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row1.Driver.AirDistribution': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['UP', 'MIDDLE', 'DOWN'],
    defaultValue: 'MIDDLE',
  ),
  'Vehicle.Cabin.HVAC.Station.Row1.Passenger.Temperature': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'celsius',
    min: 16,
    max: 30,
    defaultValue: 21.0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row1.Passenger.FanSpeed': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row1.Passenger.AirDistribution': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['UP', 'MIDDLE', 'DOWN'],
    defaultValue: 'MIDDLE',
  ),
  'Vehicle.Cabin.HVAC.Station.Row2.Driver.Temperature': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'celsius',
    min: 16,
    max: 30,
    defaultValue: 21.0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row2.Driver.FanSpeed': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row2.Driver.AirDistribution': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['UP', 'MIDDLE', 'DOWN'],
    defaultValue: 'MIDDLE',
  ),
  'Vehicle.Cabin.HVAC.Station.Row2.Passenger.Temperature': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'celsius',
    min: 16,
    max: 30,
    defaultValue: 21.0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row2.Passenger.FanSpeed': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.HVAC.Station.Row2.Passenger.AirDistribution': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['UP', 'MIDDLE', 'DOWN'],
    defaultValue: 'MIDDLE',
  ),
  'Vehicle.Cabin.HVAC.IsAirConditioningActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.IsRecirculationActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.IsFrontDefrosterActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.IsRearDefrosterActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.AmbientAirTemperature': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'celsius',
    min: -40,
    max: 80,
    defaultValue: 20.0,
  ),
  'Vehicle.Cabin.HVAC.IsAutoActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.IsSyncActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.HVAC.IsRearControlLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.AmbientLighting.ColorHex': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.AmbientLighting.Brightness': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.AmbientLighting.AnimationMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.HeadUpDisplay.IsEnabled': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.HeadUpDisplay.Height': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Cabin.HeadUpDisplay.Mode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.Sentry.Mode': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['OFF', 'ARMED'],
    defaultValue: 'OFF',
  ),
  'Vehicle.Cabin.Sentry.ThreatLevel': VssSignalMeta(type: VssNodeType.sensor, datatype: 'uint8'),
  'Vehicle.Cabin.ValetMode.IsEnabled': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Glovebox.IsLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.ConvertibleTop.Position': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', min: 0, max: 1),
  'Vehicle.Cabin.Seat.Row1.DriverSide.OccupancyStatus': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
    allowed: ['UNKNOWN', 'OCCUPIED', 'EMPTY'],
    defaultValue: 'EMPTY',
  ),
  'Vehicle.Cabin.Seat.Row1.DriverSide.IsBelted': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Seat.Row1.DriverSide.HeatingCooling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'int8',
    unit: 'percent',
    min: -100,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row1.DriverSide.Massage.Level': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row1.DriverSide.Massage.TypeActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['WAVE', 'PULSE', 'STRETCH'],
    defaultValue: 'WAVE',
  ),
  'Vehicle.Cabin.Seat.Row1.DriverSide.Backrest.SideBolsterSupport': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'percent',
    min: 0,
    max: 100,
  ),
  'Vehicle.Cabin.Seat.Row1.PassengerSide.OccupancyStatus': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
    allowed: ['UNKNOWN', 'OCCUPIED', 'EMPTY'],
    defaultValue: 'EMPTY',
  ),
  'Vehicle.Cabin.Seat.Row1.PassengerSide.IsBelted': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Seat.Row1.PassengerSide.HeatingCooling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'int8',
    unit: 'percent',
    min: -100,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row1.PassengerSide.Massage.Level': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row1.PassengerSide.Massage.TypeActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['WAVE', 'PULSE', 'STRETCH'],
    defaultValue: 'WAVE',
  ),
  'Vehicle.Cabin.Seat.Row2.DriverSide.OccupancyStatus': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
    allowed: ['UNKNOWN', 'OCCUPIED', 'EMPTY'],
    defaultValue: 'EMPTY',
  ),
  'Vehicle.Cabin.Seat.Row2.DriverSide.IsBelted': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Seat.Row2.DriverSide.HeatingCooling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'int8',
    unit: 'percent',
    min: -100,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row2.DriverSide.Massage.Level': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row2.DriverSide.Massage.TypeActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['WAVE', 'PULSE', 'STRETCH'],
    defaultValue: 'WAVE',
  ),
  'Vehicle.Cabin.Seat.Row2.DriverSide.Backrest.Recline': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'degrees',
  ),
  'Vehicle.Cabin.Seat.Row2.PassengerSide.OccupancyStatus': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
    allowed: ['UNKNOWN', 'OCCUPIED', 'EMPTY'],
    defaultValue: 'EMPTY',
  ),
  'Vehicle.Cabin.Seat.Row2.PassengerSide.IsBelted': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Cabin.Seat.Row2.PassengerSide.HeatingCooling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'int8',
    unit: 'percent',
    min: -100,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row2.PassengerSide.Massage.Level': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Seat.Row2.PassengerSide.Massage.TypeActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['WAVE', 'PULSE', 'STRETCH'],
    defaultValue: 'WAVE',
  ),
  'Vehicle.Cabin.Seat.Row2.PassengerSide.Backrest.Recline': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'degrees',
  ),
  'Vehicle.Chassis.SteeringWheel.Angle': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'degrees',
    min: -540,
    max: 540,
    defaultValue: 0.0,
  ),
  'Vehicle.Chassis.SteeringWheel.HeatingCooling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'int8',
    unit: 'percent',
    min: -100,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Chassis.RearAxleSteering.Angle': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Chassis.Suspension.Height': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['LOW', 'NORMAL', 'HIGH', 'OFFROAD_MAX'],
    defaultValue: 'NORMAL',
  ),
  'Vehicle.Chassis.Suspension.DampingMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Chassis.Suspension.AutoLeveling.Status': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Chassis.Brake.RegenMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Chassis.Brake.PedalPosition': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'uint8',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Chassis.Axle.Row2.Differential.IsLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Powertrain.TorqueSplit.RearPercent': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.StateOfCharge': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'percent',
    min: 0,
    max: 100,
    defaultValue: 80.0,
  ),
  'Vehicle.Powertrain.TractionBattery.Power': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.Temperature': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.Preconditioning.Status': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
  ),
  'Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Powertrain.TractionBattery.Charging.IsConnected': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Powertrain.TractionBattery.Charging.IsCharging': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Powertrain.TractionBattery.Charging.ChargePower': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.Charging.TargetSoC': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'percent',
    min: 0,
    max: 100,
  ),
  'Vehicle.Powertrain.TractionBattery.Charging.ChargePortFlap': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['OPEN', 'CLOSED'],
    defaultValue: 'CLOSED',
  ),
  'Vehicle.Powertrain.TractionBattery.Charging.IsChargingCableLocked': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Powertrain.V2L.IsExportingPower': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Powertrain.CombustionEngine.Speed': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.Transmission.SelectedGear': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['PARK', 'REVERSE', 'NEUTRAL', 'DRIVE'],
    defaultValue: 'PARK',
  ),
  'Vehicle.Body.Trunk.IsAjar': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Body.Trunk.PowerOpeningAngle': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'degrees',
    min: 0,
    max: 90,
    defaultValue: 0.0,
  ),
  'Vehicle.Body.Trunk.Front.IsOpen': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Body.Trailer.IsConnected': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Body.Trailer.BrakeGain': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Body.Lights.IsLeftIndicatorOn': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Body.Lights.IsRightIndicatorOn': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Body.Lights.IsHazardOn': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Body.Lights.MatrixBeamMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Body.IsCrashDetected': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Media.ActiveSoundDesign': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Media.ActiveNoiseCancellation': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Media.SoundZoneBalance': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.ADAS.ACC.IsEngaged': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.ADAS.ACC.SetSpeed': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'km/h',
    min: 30,
    max: 180,
    defaultValue: 100.0,
  ),
  'Vehicle.ADAS.ObstacleDetection.LeadVehicle': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.ADAS.LaneKeepingAssist.Status': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.ADAS.LaneKeepingAssist.LeftLaneOffsetMeters': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.ADAS.LaneKeepingAssist.RightLaneOffsetMeters': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.ADAS.LaneKeepingAssist.IsEnabled': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.ADAS.HillDescentControl.IsEnabled': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.ADAS.ESC.Mode': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['NORMAL', 'WET', 'SPORT_PLUS', 'OFF'],
    defaultValue: 'NORMAL',
  ),
  'Vehicle.ADAS.SpeedLimiter.SetSpeed': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'km/h',
    min: 30,
    max: 250,
    defaultValue: 250.0,
  ),
  'Vehicle.Software.OTA.Status': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
    allowed: ['IDLE', 'UPDATE_AVAILABLE', 'INSTALLING'],
    defaultValue: 'UPDATE_AVAILABLE',
  ),
  'Vehicle.Software.OTA.IsInstalling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Exterior.AirTemperature': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'celsius',
    min: -40,
    max: 60,
    defaultValue: 20.0,
  ),
};
