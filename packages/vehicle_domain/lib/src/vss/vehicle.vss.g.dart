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

  /// State of the supply voltage of the control units (usually 12V).
  VssSignal<String> get LowVoltageSystemState => const VssSignal<String>('Vehicle.LowVoltageSystemState');

  /// Odometer reading, total distance traveled during the lifetime of the vehicle.
  VssSignal<int> get TraveledDistance => const VssSignal<int>('Vehicle.TraveledDistance');

  /// Trip meter reading. The driver can reset it.
  VssSignal<int> get TripMeterReading => const VssSignal<int>('Vehicle.TripMeterReading');

  /// Signals related to low voltage battery.
  _VssVehicleLowVoltageBattery get LowVoltageBattery => const _VssVehicleLowVoltageBattery();

  /// Custom (not in COVESA VSS). Driver power requests (start button / power off).
  _VssVehiclePowerMode get PowerMode => const _VssVehiclePowerMode();
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

  /// Sunroof position. 0 = Fully closed 100 = Fully opened. -100 = Fully tilted.
  VssSignal<int> get Position => const VssSignal<int>('Vehicle.Cabin.Sunroof.Position');

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

  /// Is door open or closed. True = Open. False = Closed.
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.DriverSide.IsOpen');

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.DriverSide.IsLocked');

  /// Custom signal (not in COVESA VSS).
  VssSignal<String> get SoftCloseState => const VssSignal<String>('Vehicle.Cabin.Door.Row1.DriverSide.SoftCloseState');
}

final class _VssVehicleCabinDoorRow1PassengerSide {
  const _VssVehicleCabinDoorRow1PassengerSide();

  /// Is door open or closed. True = Open. False = Closed.
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

  /// Is door open or closed. True = Open. False = Closed.
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

  /// Is door open or closed. True = Open. False = Closed.
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

  /// Parking brake signals.
  _VssVehicleChassisParkingBrake get ParkingBrake => const _VssVehicleChassisParkingBrake();
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

  /// Front axle.
  _VssVehicleChassisAxleRow1 get Row1 => const _VssVehicleChassisAxleRow1();
}

final class _VssVehicleChassisAxleRow2 {
  const _VssVehicleChassisAxleRow2();

  _VssVehicleChassisAxleRow2Differential get Differential => const _VssVehicleChassisAxleRow2Differential();

  /// Wheels.
  _VssVehicleChassisAxleRow2Wheel get Wheel => const _VssVehicleChassisAxleRow2Wheel();
}

final class _VssVehicleChassisAxleRow2Differential {
  const _VssVehicleChassisAxleRow2Differential();

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Chassis.Axle.Row2.Differential.IsLocked');
}

final class _VssVehicleChassisAxleRow2Wheel {
  const _VssVehicleChassisAxleRow2Wheel();

  /// Left wheel.
  _VssVehicleChassisAxleRow2WheelLeft get Left => const _VssVehicleChassisAxleRow2WheelLeft();

  /// Right wheel.
  _VssVehicleChassisAxleRow2WheelRight get Right => const _VssVehicleChassisAxleRow2WheelRight();
}

final class _VssVehicleChassisAxleRow2WheelLeft {
  const _VssVehicleChassisAxleRow2WheelLeft();

  /// Tire signals.
  _VssVehicleChassisAxleRow2WheelLeftTire get Tire => const _VssVehicleChassisAxleRow2WheelLeftTire();
}

final class _VssVehicleChassisAxleRow2WheelLeftTire {
  const _VssVehicleChassisAxleRow2WheelLeftTire();

  /// Tire Pressure Status. True = Low tire pressure.
  VssSignal<bool> get IsPressureLow => const VssSignal<bool>('Vehicle.Chassis.Axle.Row2.Wheel.Left.Tire.IsPressureLow');
}

final class _VssVehicleChassisAxleRow2WheelRight {
  const _VssVehicleChassisAxleRow2WheelRight();

  /// Tire signals.
  _VssVehicleChassisAxleRow2WheelRightTire get Tire => const _VssVehicleChassisAxleRow2WheelRightTire();
}

final class _VssVehicleChassisAxleRow2WheelRightTire {
  const _VssVehicleChassisAxleRow2WheelRightTire();

  /// Tire Pressure Status. True = Low tire pressure.
  VssSignal<bool> get IsPressureLow =>
      const VssSignal<bool>('Vehicle.Chassis.Axle.Row2.Wheel.Right.Tire.IsPressureLow');
}

final class _VssVehicleChassisAxleRow1 {
  const _VssVehicleChassisAxleRow1();

  /// Wheels.
  _VssVehicleChassisAxleRow1Wheel get Wheel => const _VssVehicleChassisAxleRow1Wheel();
}

final class _VssVehicleChassisAxleRow1Wheel {
  const _VssVehicleChassisAxleRow1Wheel();

  /// Left wheel.
  _VssVehicleChassisAxleRow1WheelLeft get Left => const _VssVehicleChassisAxleRow1WheelLeft();

  /// Right wheel.
  _VssVehicleChassisAxleRow1WheelRight get Right => const _VssVehicleChassisAxleRow1WheelRight();
}

final class _VssVehicleChassisAxleRow1WheelLeft {
  const _VssVehicleChassisAxleRow1WheelLeft();

  /// Tire signals.
  _VssVehicleChassisAxleRow1WheelLeftTire get Tire => const _VssVehicleChassisAxleRow1WheelLeftTire();
}

final class _VssVehicleChassisAxleRow1WheelLeftTire {
  const _VssVehicleChassisAxleRow1WheelLeftTire();

  /// Tire Pressure Status. True = Low tire pressure.
  VssSignal<bool> get IsPressureLow => const VssSignal<bool>('Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.IsPressureLow');
}

final class _VssVehicleChassisAxleRow1WheelRight {
  const _VssVehicleChassisAxleRow1WheelRight();

  /// Tire signals.
  _VssVehicleChassisAxleRow1WheelRightTire get Tire => const _VssVehicleChassisAxleRow1WheelRightTire();
}

final class _VssVehicleChassisAxleRow1WheelRightTire {
  const _VssVehicleChassisAxleRow1WheelRightTire();

  /// Tire Pressure Status. True = Low tire pressure.
  VssSignal<bool> get IsPressureLow =>
      const VssSignal<bool>('Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.IsPressureLow');
}

final class _VssVehicleChassisParkingBrake {
  const _VssVehicleChassisParkingBrake();

  /// Parking brake status. True = Parking Brake is Engaged.
  VssSignal<bool> get IsEngaged => const VssSignal<bool>('Vehicle.Chassis.ParkingBrake.IsEngaged');
}

final class _VssVehiclePowertrain {
  const _VssVehiclePowertrain();

  _VssVehiclePowertrainTorqueSplit get TorqueSplit => const _VssVehiclePowertrainTorqueSplit();

  _VssVehiclePowertrainTractionBattery get TractionBattery => const _VssVehiclePowertrainTractionBattery();

  _VssVehiclePowertrainV2L get V2L => const _VssVehiclePowertrainV2L();

  _VssVehiclePowertrainCombustionEngine get CombustionEngine => const _VssVehiclePowertrainCombustionEngine();

  _VssVehiclePowertrainTransmission get Transmission => const _VssVehiclePowertrainTransmission();

  /// Remaining range in meters using all energy sources available in the vehicle.
  VssSignal<int> get Range => const VssSignal<int>('Vehicle.Powertrain.Range');
}

final class _VssVehiclePowertrainTorqueSplit {
  const _VssVehiclePowertrainTorqueSplit();

  VssSignal<double> get RearPercent => const VssSignal<double>('Vehicle.Powertrain.TorqueSplit.RearPercent');
}

final class _VssVehiclePowertrainTractionBattery {
  const _VssVehiclePowertrainTractionBattery();

  VssSignal<double> get StateOfCharge => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.StateOfCharge');

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.Temperature');

  _VssVehiclePowertrainTractionBatteryPreconditioning get Preconditioning =>
      const _VssVehiclePowertrainTractionBatteryPreconditioning();

  _VssVehiclePowertrainTractionBatteryCharging get Charging => const _VssVehiclePowertrainTractionBatteryCharging();

  /// Current electrical energy flowing in/out of battery. Positive = Energy flowing in to battery, e.g. during charging. Negative = Energy flowing out of battery, e.g. during driving.
  VssSignal<double> get CurrentPower => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.CurrentPower');

  /// Indicating if the high voltage battery is connected (contactors closed).
  VssSignal<bool> get IsPowerConnected => const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.IsPowerConnected');
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

  /// The selected gear. 0=Neutral, 1/2/..=Forward, -1/-2/..=Reverse, 126=Park, 127=Drive.
  VssSignal<int> get SelectedGear => const VssSignal<int>('Vehicle.Powertrain.Transmission.SelectedGear');
}

final class _VssVehicleBody {
  const _VssVehicleBody();

  _VssVehicleBodyTrunk get Trunk => const _VssVehicleBodyTrunk();

  _VssVehicleBodyTrailer get Trailer => const _VssVehicleBodyTrailer();

  _VssVehicleBodyLights get Lights => const _VssVehicleBodyLights();

  VssSignal<bool> get IsCrashDetected => const VssSignal<bool>('Vehicle.Body.IsCrashDetected');

  /// Custom (not in COVESA VSS). Passive entry / passive start.
  _VssVehicleBodyKeyless get Keyless => const _VssVehicleBodyKeyless();
}

final class _VssVehicleBodyTrunk {
  const _VssVehicleBodyTrunk();

  _VssVehicleBodyTrunkFront get Front => const _VssVehicleBodyTrunkFront();

  /// Rear trunk (power tailgate).
  _VssVehicleBodyTrunkRear get Rear => const _VssVehicleBodyTrunkRear();
}

final class _VssVehicleBodyTrunkFront {
  const _VssVehicleBodyTrunkFront();

  /// Front trunk (frunk).
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Body.Trunk.Front.IsOpen');
}

final class _VssVehicleBodyTrunkRear {
  const _VssVehicleBodyTrunkRear();

  /// Is trunk open or closed. True = Open. False = Closed.
  VssSignal<bool> get IsOpen => const VssSignal<bool>('Vehicle.Body.Trunk.Rear.IsOpen');
}

final class _VssVehicleBodyTrailer {
  const _VssVehicleBodyTrailer();

  VssSignal<bool> get IsConnected => const VssSignal<bool>('Vehicle.Body.Trailer.IsConnected');

  VssSignal<double> get BrakeGain => const VssSignal<double>('Vehicle.Body.Trailer.BrakeGain');
}

final class _VssVehicleBodyLights {
  const _VssVehicleBodyLights();

  VssSignal<String> get MatrixBeamMode => const VssSignal<String>('Vehicle.Body.Lights.MatrixBeamMode');

  /// Indicator lights.
  _VssVehicleBodyLightsDirectionIndicator get DirectionIndicator => const _VssVehicleBodyLightsDirectionIndicator();

  /// Hazard lights.
  _VssVehicleBodyLightsHazard get Hazard => const _VssVehicleBodyLightsHazard();

  /// Beam lights.
  _VssVehicleBodyLightsBeam get Beam => const _VssVehicleBodyLightsBeam();
}

final class _VssVehicleBodyLightsDirectionIndicator {
  const _VssVehicleBodyLightsDirectionIndicator();

  /// Left indicator.
  _VssVehicleBodyLightsDirectionIndicatorLeft get Left => const _VssVehicleBodyLightsDirectionIndicatorLeft();

  /// Right indicator.
  _VssVehicleBodyLightsDirectionIndicatorRight get Right => const _VssVehicleBodyLightsDirectionIndicatorRight();
}

final class _VssVehicleBodyLightsDirectionIndicatorLeft {
  const _VssVehicleBodyLightsDirectionIndicatorLeft();

  /// Indicates if light is signaling or off.
  VssSignal<bool> get IsSignaling => const VssSignal<bool>('Vehicle.Body.Lights.DirectionIndicator.Left.IsSignaling');
}

final class _VssVehicleBodyLightsDirectionIndicatorRight {
  const _VssVehicleBodyLightsDirectionIndicatorRight();

  /// Indicates if light is signaling or off.
  VssSignal<bool> get IsSignaling => const VssSignal<bool>('Vehicle.Body.Lights.DirectionIndicator.Right.IsSignaling');
}

final class _VssVehicleBodyLightsHazard {
  const _VssVehicleBodyLightsHazard();

  /// Indicates if light is signaling or off.
  VssSignal<bool> get IsSignaling => const VssSignal<bool>('Vehicle.Body.Lights.Hazard.IsSignaling');
}

final class _VssVehicleBodyLightsBeam {
  const _VssVehicleBodyLightsBeam();

  /// Low beam.
  _VssVehicleBodyLightsBeamLow get Low => const _VssVehicleBodyLightsBeamLow();

  /// High beam.
  _VssVehicleBodyLightsBeamHigh get High => const _VssVehicleBodyLightsBeamHigh();
}

final class _VssVehicleBodyLightsBeamLow {
  const _VssVehicleBodyLightsBeamLow();

  /// Indicates if light is on or off.
  VssSignal<bool> get IsOn => const VssSignal<bool>('Vehicle.Body.Lights.Beam.Low.IsOn');
}

final class _VssVehicleBodyLightsBeamHigh {
  const _VssVehicleBodyLightsBeamHigh();

  /// Indicates if light is on or off.
  VssSignal<bool> get IsOn => const VssSignal<bool>('Vehicle.Body.Lights.Beam.High.IsOn');
}

final class _VssVehicleBodyKeyless {
  const _VssVehicleBodyKeyless();

  /// Custom (not in COVESA VSS). Where the key (fob or phone key) is detected.
  VssSignal<String> get KeyLocation => const VssSignal<String>('Vehicle.Body.Keyless.KeyLocation');
}

final class _VssVehicleMedia {
  const _VssVehicleMedia();

  VssSignal<String> get ActiveSoundDesign => const VssSignal<String>('Vehicle.Media.ActiveSoundDesign');

  VssSignal<bool> get ActiveNoiseCancellation => const VssSignal<bool>('Vehicle.Media.ActiveNoiseCancellation');

  VssSignal<String> get SoundZoneBalance => const VssSignal<String>('Vehicle.Media.SoundZoneBalance');
}

final class _VssVehicleADAS {
  const _VssVehicleADAS();

  _VssVehicleADASObstacleDetection get ObstacleDetection => const _VssVehicleADASObstacleDetection();

  /// Custom (not in COVESA VSS). Lane keeping assist and lane geometry from the front camera.
  _VssVehicleADASLaneKeepingAssist get LaneKeepingAssist => const _VssVehicleADASLaneKeepingAssist();

  _VssVehicleADASHillDescentControl get HillDescentControl => const _VssVehicleADASHillDescentControl();

  _VssVehicleADASESC get ESC => const _VssVehicleADASESC();

  /// Custom (not in COVESA VSS). Driver-set speed limiter.
  _VssVehicleADASSpeedLimiter get SpeedLimiter => const _VssVehicleADASSpeedLimiter();

  /// Signals from Cruise Control system.
  _VssVehicleADASCruiseControl get CruiseControl => const _VssVehicleADASCruiseControl();

  /// Signals from Lane Departure Detection System.
  _VssVehicleADASLaneDepartureDetection get LaneDepartureDetection => const _VssVehicleADASLaneDepartureDetection();

  /// Custom (not in COVESA VSS). Traffic sign recognition.
  _VssVehicleADASTrafficSignRecognition get TrafficSignRecognition => const _VssVehicleADASTrafficSignRecognition();
}

final class _VssVehicleADASObstacleDetection {
  const _VssVehicleADASObstacleDetection();

  /// Front obstacle detection.
  _VssVehicleADASObstacleDetectionFront get Front => const _VssVehicleADASObstacleDetectionFront();
}

final class _VssVehicleADASObstacleDetectionFront {
  const _VssVehicleADASObstacleDetectionFront();

  /// Front center sensor.
  _VssVehicleADASObstacleDetectionFrontCenter get Center => const _VssVehicleADASObstacleDetectionFrontCenter();
}

final class _VssVehicleADASObstacleDetectionFrontCenter {
  const _VssVehicleADASObstacleDetectionFrontCenter();

  /// Distance in meters to detected object. 250 = nothing in range.
  VssSignal<double> get Distance => const VssSignal<double>('Vehicle.ADAS.ObstacleDetection.Front.Center.Distance');

  /// Indicates if a forward collision warning is active.
  VssSignal<bool> get IsWarning => const VssSignal<bool>('Vehicle.ADAS.ObstacleDetection.Front.Center.IsWarning');
}

final class _VssVehicleADASLaneKeepingAssist {
  const _VssVehicleADASLaneKeepingAssist();

  /// Custom (not in COVESA VSS). Lane keeping assist switch.
  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.ADAS.LaneKeepingAssist.IsEnabled');

  /// Custom (not in COVESA VSS). Ego offset from the lane center. Positive = right of center.
  VssSignal<double> get LateralOffset => const VssSignal<double>('Vehicle.ADAS.LaneKeepingAssist.LateralOffset');

  /// Custom (not in COVESA VSS). Lane curvature ahead. Positive = curving right.
  VssSignal<double> get Curvature => const VssSignal<double>('Vehicle.ADAS.LaneKeepingAssist.Curvature');
}

final class _VssVehicleADASHillDescentControl {
  const _VssVehicleADASHillDescentControl();

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.ADAS.HillDescentControl.IsEnabled');
}

final class _VssVehicleADASESC {
  const _VssVehicleADASESC();

  /// Electronic stability control mode.
  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.ADAS.ESC.Mode');

  /// Indicates if ESC is currently regulating vehicle stability. True = Engaged.
  VssSignal<bool> get IsEngaged => const VssSignal<bool>('Vehicle.ADAS.ESC.IsEngaged');
}

final class _VssVehicleADASSpeedLimiter {
  const _VssVehicleADASSpeedLimiter();

  VssSignal<double> get SetSpeed => const VssSignal<double>('Vehicle.ADAS.SpeedLimiter.SetSpeed');
}

final class _VssVehicleADASCruiseControl {
  const _VssVehicleADASCruiseControl();

  /// Indicates if cruise control system is active (i.e. actively controls speed). True = Active. False = Inactive.
  VssSignal<bool> get IsActive => const VssSignal<bool>('Vehicle.ADAS.CruiseControl.IsActive');

  /// Set cruise control speed in kilometers per hour.
  VssSignal<double> get SpeedSet => const VssSignal<double>('Vehicle.ADAS.CruiseControl.SpeedSet');

  /// Set cruise control time interval (gap) in seconds.
  VssSignal<double> get AdaptiveIntervalSet =>
      const VssSignal<double>('Vehicle.ADAS.CruiseControl.AdaptiveIntervalSet');
}

final class _VssVehicleADASLaneDepartureDetection {
  const _VssVehicleADASLaneDepartureDetection();

  /// Indicates if lane departure detection registered a lane departure.
  VssSignal<bool> get IsWarning => const VssSignal<bool>('Vehicle.ADAS.LaneDepartureDetection.IsWarning');
}

final class _VssVehicleADASTrafficSignRecognition {
  const _VssVehicleADASTrafficSignRecognition();

  /// Custom (not in COVESA VSS). Current speed limit from signs or map. 0 = unknown.
  VssSignal<int> get SpeedLimit => const VssSignal<int>('Vehicle.ADAS.TrafficSignRecognition.SpeedLimit');
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

final class _VssVehicleLowVoltageBattery {
  const _VssVehicleLowVoltageBattery();

  /// Current voltage of the low voltage battery.
  VssSignal<double> get CurrentVoltage => const VssSignal<double>('Vehicle.LowVoltageBattery.CurrentVoltage');
}

final class _VssVehiclePowerMode {
  const _VssVehiclePowerMode();

  /// Custom (not in COVESA VSS). Requested power mode. READY closes the high-voltage contactors.
  VssSignal<String> get Request => const VssSignal<String>('Vehicle.PowerMode.Request');
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
    datatype: 'int8',
    unit: 'percent',
    min: -100,
    max: 100,
    defaultValue: 0,
  ),
  'Vehicle.Cabin.Sunroof.IsFaulted': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Sunroof.ElectrochromicOpacity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.Door.Row1.DriverSide.IsOpen': VssSignalMeta(
    type: VssNodeType.actuator,
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
    type: VssNodeType.actuator,
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
    type: VssNodeType.actuator,
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
    type: VssNodeType.actuator,
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
  'Vehicle.Chassis.Axle.Row2.Wheel.Left.Tire.IsPressureLow': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Chassis.Axle.Row2.Wheel.Right.Tire.IsPressureLow': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Chassis.Axle.Row1.Wheel.Left.Tire.IsPressureLow': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Chassis.Axle.Row1.Wheel.Right.Tire.IsPressureLow': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Chassis.ParkingBrake.IsEngaged': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: true,
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
  'Vehicle.Powertrain.TractionBattery.CurrentPower': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'W',
    defaultValue: 0.0,
  ),
  'Vehicle.Powertrain.TractionBattery.IsPowerConnected': VssSignalMeta(
    type: VssNodeType.sensor,
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
    datatype: 'int8',
    defaultValue: 126,
  ),
  'Vehicle.Powertrain.Range': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'uint32',
    unit: 'm',
    defaultValue: 420000,
  ),
  'Vehicle.Body.Trunk.Front.IsOpen': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Body.Trunk.Rear.IsOpen': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Body.Trailer.IsConnected': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Body.Trailer.BrakeGain': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Body.Lights.MatrixBeamMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Body.Lights.DirectionIndicator.Left.IsSignaling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Body.Lights.DirectionIndicator.Right.IsSignaling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Body.Lights.Hazard.IsSignaling': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Body.Lights.Beam.Low.IsOn': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: true,
  ),
  'Vehicle.Body.Lights.Beam.High.IsOn': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.Body.IsCrashDetected': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Body.Keyless.KeyLocation': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
    allowed: ['NONE', 'NEAR', 'INSIDE'],
    defaultValue: 'INSIDE',
  ),
  'Vehicle.Media.ActiveSoundDesign': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Media.ActiveNoiseCancellation': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Media.SoundZoneBalance': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.ADAS.ObstacleDetection.Front.Center.Distance': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'm',
    min: 0,
    max: 250,
    defaultValue: 250.0,
  ),
  'Vehicle.ADAS.ObstacleDetection.Front.Center.IsWarning': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.ADAS.LaneKeepingAssist.IsEnabled': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.ADAS.LaneKeepingAssist.LateralOffset': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'm',
    min: -2,
    max: 2,
    defaultValue: 0.0,
  ),
  'Vehicle.ADAS.LaneKeepingAssist.Curvature': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: '1/m',
    min: -0.02,
    max: 0.02,
    defaultValue: 0.0,
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
  'Vehicle.ADAS.ESC.IsEngaged': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.ADAS.SpeedLimiter.SetSpeed': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'km/h',
    min: 30,
    max: 250,
    defaultValue: 250.0,
  ),
  'Vehicle.ADAS.CruiseControl.IsActive': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.ADAS.CruiseControl.SpeedSet': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 'km/h',
    min: 30,
    max: 180,
    defaultValue: 100.0,
  ),
  'Vehicle.ADAS.CruiseControl.AdaptiveIntervalSet': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'float',
    unit: 's',
    min: 1,
    max: 3,
    defaultValue: 2.0,
  ),
  'Vehicle.ADAS.LaneDepartureDetection.IsWarning': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'boolean',
    defaultValue: false,
  ),
  'Vehicle.ADAS.TrafficSignRecognition.SpeedLimit': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'uint16',
    unit: 'km/h',
    defaultValue: 0,
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
  'Vehicle.LowVoltageSystemState': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'string',
    allowed: ['UNDEFINED', 'LOCK', 'OFF', 'ACC', 'ON', 'START'],
    defaultValue: 'ON',
  ),
  'Vehicle.TraveledDistance': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'uint32',
    unit: 'm',
    defaultValue: 18432000,
  ),
  'Vehicle.TripMeterReading': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint32', unit: 'm', defaultValue: 0),
  'Vehicle.LowVoltageBattery.CurrentVoltage': VssSignalMeta(
    type: VssNodeType.sensor,
    datatype: 'float',
    unit: 'V',
    min: 0,
    max: 16,
    defaultValue: 12.6,
  ),
  'Vehicle.PowerMode.Request': VssSignalMeta(
    type: VssNodeType.actuator,
    datatype: 'string',
    allowed: ['OFF', 'ACC', 'ON', 'READY'],
    defaultValue: 'ON',
  ),
};
