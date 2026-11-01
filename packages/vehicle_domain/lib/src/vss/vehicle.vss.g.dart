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

  _VssVehicleSeat get Seat => const _VssVehicleSeat();

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

  _VssVehicleCabinDoorRow1Left get Left => const _VssVehicleCabinDoorRow1Left();

  _VssVehicleCabinDoorRow1Right get Right => const _VssVehicleCabinDoorRow1Right();
}

final class _VssVehicleCabinDoorRow1Left {
  const _VssVehicleCabinDoorRow1Left();

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.Left.IsLocked');

  VssSignal<bool> get IsAjar => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.Left.IsAjar');

  VssSignal<String> get SoftCloseState => const VssSignal<String>('Vehicle.Cabin.Door.Row1.Left.SoftCloseState');
}

final class _VssVehicleCabinDoorRow1Right {
  const _VssVehicleCabinDoorRow1Right();

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.Right.IsLocked');

  VssSignal<bool> get IsAjar => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.Right.IsAjar');

  VssSignal<String> get SoftCloseState => const VssSignal<String>('Vehicle.Cabin.Door.Row1.Right.SoftCloseState');
}

final class _VssVehicleCabinDoorRow2 {
  const _VssVehicleCabinDoorRow2();

  _VssVehicleCabinDoorRow2Left get Left => const _VssVehicleCabinDoorRow2Left();

  _VssVehicleCabinDoorRow2Right get Right => const _VssVehicleCabinDoorRow2Right();
}

final class _VssVehicleCabinDoorRow2Left {
  const _VssVehicleCabinDoorRow2Left();

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.Left.IsLocked');

  VssSignal<bool> get IsAjar => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.Left.IsAjar');

  VssSignal<double> get SunshadePosition => const VssSignal<double>('Vehicle.Cabin.Door.Row2.Left.SunshadePosition');
}

final class _VssVehicleCabinDoorRow2Right {
  const _VssVehicleCabinDoorRow2Right();

  VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.Right.IsLocked');

  VssSignal<bool> get IsAjar => const VssSignal<bool>('Vehicle.Cabin.Door.Row2.Right.IsAjar');

  VssSignal<double> get SunshadePosition => const VssSignal<double>('Vehicle.Cabin.Door.Row2.Right.SunshadePosition');
}

final class _VssVehicleCabinHVAC {
  const _VssVehicleCabinHVAC();

  _VssVehicleCabinHVACAirConditioning get AirConditioning => const _VssVehicleCabinHVACAirConditioning();

  VssSignal<int> get AirQuality => const VssSignal<int>('Vehicle.Cabin.HVAC.AirQuality');

  VssSignal<bool> get IonizerIsEnabled => const VssSignal<bool>('Vehicle.Cabin.HVAC.IonizerIsEnabled');

  _VssVehicleCabinHVACFragrance get Fragrance => const _VssVehicleCabinHVACFragrance();

  _VssVehicleCabinHVACDogMode get DogMode => const _VssVehicleCabinHVACDogMode();

  _VssVehicleCabinHVACRow1 get Row1 => const _VssVehicleCabinHVACRow1();

  _VssVehicleCabinHVACRow2 get Row2 => const _VssVehicleCabinHVACRow2();
}

final class _VssVehicleCabinHVACAirConditioning {
  const _VssVehicleCabinHVACAirConditioning();

  VssSignal<bool> get StationaryPreconditioning => const VssSignal<bool>('Vehicle.Cabin.HVAC.AirConditioning.StationaryPreconditioning');
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

final class _VssVehicleCabinHVACRow1 {
  const _VssVehicleCabinHVACRow1();

  _VssVehicleCabinHVACRow1Left get Left => const _VssVehicleCabinHVACRow1Left();

  _VssVehicleCabinHVACRow1Right get Right => const _VssVehicleCabinHVACRow1Right();
}

final class _VssVehicleCabinHVACRow1Left {
  const _VssVehicleCabinHVACRow1Left();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Row1.Left.Temperature');

  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Row1.Left.FanSpeed');
}

final class _VssVehicleCabinHVACRow1Right {
  const _VssVehicleCabinHVACRow1Right();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Row1.Right.Temperature');

  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Row1.Right.FanSpeed');
}

final class _VssVehicleCabinHVACRow2 {
  const _VssVehicleCabinHVACRow2();

  _VssVehicleCabinHVACRow2Left get Left => const _VssVehicleCabinHVACRow2Left();

  _VssVehicleCabinHVACRow2Right get Right => const _VssVehicleCabinHVACRow2Right();
}

final class _VssVehicleCabinHVACRow2Left {
  const _VssVehicleCabinHVACRow2Left();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Row2.Left.Temperature');

  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Row2.Left.FanSpeed');
}

final class _VssVehicleCabinHVACRow2Right {
  const _VssVehicleCabinHVACRow2Right();

  VssSignal<double> get Temperature => const VssSignal<double>('Vehicle.Cabin.HVAC.Row2.Right.Temperature');

  VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Row2.Right.FanSpeed');
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

final class _VssVehicleSeat {
  const _VssVehicleSeat();

  _VssVehicleSeatRow1 get Row1 => const _VssVehicleSeatRow1();

  _VssVehicleSeatRow2 get Row2 => const _VssVehicleSeatRow2();
}

final class _VssVehicleSeatRow1 {
  const _VssVehicleSeatRow1();

  _VssVehicleSeatRow1Left get Left => const _VssVehicleSeatRow1Left();

  _VssVehicleSeatRow1Right get Right => const _VssVehicleSeatRow1Right();
}

final class _VssVehicleSeatRow1Left {
  const _VssVehicleSeatRow1Left();

  VssSignal<int> get HeatingLevel => const VssSignal<int>('Vehicle.Seat.Row1.Left.HeatingLevel');

  VssSignal<int> get VentilationLevel => const VssSignal<int>('Vehicle.Seat.Row1.Left.VentilationLevel');

  _VssVehicleSeatRow1LeftMassage get Massage => const _VssVehicleSeatRow1LeftMassage();

  VssSignal<int> get MemoryProfile => const VssSignal<int>('Vehicle.Seat.Row1.Left.MemoryProfile');

  VssSignal<double> get SideBolsterSupport => const VssSignal<double>('Vehicle.Seat.Row1.Left.SideBolsterSupport');
}

final class _VssVehicleSeatRow1LeftMassage {
  const _VssVehicleSeatRow1LeftMassage();

  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.Seat.Row1.Left.Massage.Mode');

  VssSignal<int> get Intensity => const VssSignal<int>('Vehicle.Seat.Row1.Left.Massage.Intensity');
}

final class _VssVehicleSeatRow1Right {
  const _VssVehicleSeatRow1Right();

  VssSignal<int> get HeatingLevel => const VssSignal<int>('Vehicle.Seat.Row1.Right.HeatingLevel');

  VssSignal<int> get VentilationLevel => const VssSignal<int>('Vehicle.Seat.Row1.Right.VentilationLevel');

  _VssVehicleSeatRow1RightMassage get Massage => const _VssVehicleSeatRow1RightMassage();
}

final class _VssVehicleSeatRow1RightMassage {
  const _VssVehicleSeatRow1RightMassage();

  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.Seat.Row1.Right.Massage.Mode');

  VssSignal<int> get Intensity => const VssSignal<int>('Vehicle.Seat.Row1.Right.Massage.Intensity');
}

final class _VssVehicleSeatRow2 {
  const _VssVehicleSeatRow2();

  _VssVehicleSeatRow2Left get Left => const _VssVehicleSeatRow2Left();

  _VssVehicleSeatRow2Right get Right => const _VssVehicleSeatRow2Right();
}

final class _VssVehicleSeatRow2Left {
  const _VssVehicleSeatRow2Left();

  VssSignal<double> get ReclineAngle => const VssSignal<double>('Vehicle.Seat.Row2.Left.ReclineAngle');

  VssSignal<int> get HeatingLevel => const VssSignal<int>('Vehicle.Seat.Row2.Left.HeatingLevel');

  VssSignal<int> get VentilationLevel => const VssSignal<int>('Vehicle.Seat.Row2.Left.VentilationLevel');

  _VssVehicleSeatRow2LeftMassage get Massage => const _VssVehicleSeatRow2LeftMassage();
}

final class _VssVehicleSeatRow2LeftMassage {
  const _VssVehicleSeatRow2LeftMassage();

  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.Seat.Row2.Left.Massage.Mode');

  VssSignal<int> get Intensity => const VssSignal<int>('Vehicle.Seat.Row2.Left.Massage.Intensity');
}

final class _VssVehicleSeatRow2Right {
  const _VssVehicleSeatRow2Right();

  VssSignal<double> get ReclineAngle => const VssSignal<double>('Vehicle.Seat.Row2.Right.ReclineAngle');

  VssSignal<int> get HeatingLevel => const VssSignal<int>('Vehicle.Seat.Row2.Right.HeatingLevel');

  VssSignal<int> get VentilationLevel => const VssSignal<int>('Vehicle.Seat.Row2.Right.VentilationLevel');

  _VssVehicleSeatRow2RightMassage get Massage => const _VssVehicleSeatRow2RightMassage();
}

final class _VssVehicleSeatRow2RightMassage {
  const _VssVehicleSeatRow2RightMassage();

  VssSignal<String> get Mode => const VssSignal<String>('Vehicle.Seat.Row2.Right.Massage.Mode');

  VssSignal<int> get Intensity => const VssSignal<int>('Vehicle.Seat.Row2.Right.Massage.Intensity');
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

  VssSignal<bool> get Heated => const VssSignal<bool>('Vehicle.Chassis.SteeringWheel.Heated');
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

  _VssVehiclePowertrainTractionBatteryPreconditioning get Preconditioning => const _VssVehiclePowertrainTractionBatteryPreconditioning();

  _VssVehiclePowertrainTractionBatteryCharging get Charging => const _VssVehiclePowertrainTractionBatteryCharging();
}

final class _VssVehiclePowertrainTractionBatteryPreconditioning {
  const _VssVehiclePowertrainTractionBatteryPreconditioning();

  VssSignal<String> get Status => const VssSignal<String>('Vehicle.Powertrain.TractionBattery.Preconditioning.Status');

  VssSignal<bool> get IsEnabled => const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled');
}

final class _VssVehiclePowertrainTractionBatteryCharging {
  const _VssVehiclePowertrainTractionBatteryCharging();

  VssSignal<bool> get IsConnected => const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.Charging.IsConnected');

  VssSignal<bool> get IsCharging => const VssSignal<bool>('Vehicle.Powertrain.TractionBattery.Charging.IsCharging');

  VssSignal<double> get ChargePower => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.Charging.ChargePower');

  VssSignal<double> get TargetSoC => const VssSignal<double>('Vehicle.Powertrain.TractionBattery.Charging.TargetSoC');
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
}

final class _VssVehicleBodyTrunk {
  const _VssVehicleBodyTrunk();

  VssSignal<bool> get IsAjar => const VssSignal<bool>('Vehicle.Body.Trunk.IsAjar');

  VssSignal<double> get PowerOpeningAngle => const VssSignal<double>('Vehicle.Body.Trunk.PowerOpeningAngle');
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

  VssSignal<double> get LeftLaneOffsetMeters => const VssSignal<double>('Vehicle.ADAS.LaneKeepingAssist.LeftLaneOffsetMeters');

  VssSignal<double> get RightLaneOffsetMeters => const VssSignal<double>('Vehicle.ADAS.LaneKeepingAssist.RightLaneOffsetMeters');
}

final class _VssVehicleSoftware {
  const _VssVehicleSoftware();

  _VssVehicleSoftwareOTA get OTA => const _VssVehicleSoftwareOTA();
}

final class _VssVehicleSoftwareOTA {
  const _VssVehicleSoftwareOTA();

  VssSignal<String> get Status => const VssSignal<String>('Vehicle.Software.OTA.Status');
}

final class _VssVehicleExterior {
  const _VssVehicleExterior();

  VssSignal<double> get AirTemperature => const VssSignal<double>('Vehicle.Exterior.AirTemperature');
}

/// Metadata of every signal in the spec, keyed by VSS path.
const Map<String, VssSignalMeta> vssCatalog = {
  'Vehicle.Speed': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float', unit: 'km/h', min: 0, max: 300, defaultValue: 0.0),
  'Vehicle.DriveMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.Sunroof.Position': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', min: 0, max: 1, defaultValue: 0.0),
  'Vehicle.Cabin.Sunroof.IsFaulted': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Sunroof.ElectrochromicOpacity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.Door.Row1.Left.IsLocked': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row1.Left.IsAjar': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row1.Left.SoftCloseState': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Cabin.Door.Row1.Right.IsLocked': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row1.Right.IsAjar': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row1.Right.SoftCloseState': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Cabin.Door.Row2.Left.IsLocked': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row2.Left.IsAjar': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row2.Left.SunshadePosition': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.Door.Row2.Right.IsLocked': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row2.Right.IsAjar': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Cabin.Door.Row2.Right.SunshadePosition': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.HVAC.AirConditioning.StationaryPreconditioning': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.HVAC.AirQuality': VssSignalMeta(type: VssNodeType.sensor, datatype: 'uint8'),
  'Vehicle.Cabin.HVAC.IonizerIsEnabled': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.HVAC.Fragrance.ActiveCartridge': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Cabin.HVAC.Fragrance.Intensity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Cabin.HVAC.DogMode.IsEnabled': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.HVAC.DogMode.TargetTemperature': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.HVAC.Row1.Left.Temperature': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', unit: 'celsius', min: 16, max: 30),
  'Vehicle.Cabin.HVAC.Row1.Left.FanSpeed': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8', unit: 'percent', min: 0, max: 100),
  'Vehicle.Cabin.HVAC.Row1.Right.Temperature': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', unit: 'celsius', min: 16, max: 30),
  'Vehicle.Cabin.HVAC.Row1.Right.FanSpeed': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8', unit: 'percent', min: 0, max: 100),
  'Vehicle.Cabin.HVAC.Row2.Left.Temperature': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', unit: 'celsius', min: 16, max: 30),
  'Vehicle.Cabin.HVAC.Row2.Left.FanSpeed': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8', unit: 'percent', min: 0, max: 100),
  'Vehicle.Cabin.HVAC.Row2.Right.Temperature': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', unit: 'celsius', min: 16, max: 30),
  'Vehicle.Cabin.HVAC.Row2.Right.FanSpeed': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8', unit: 'percent', min: 0, max: 100),
  'Vehicle.Cabin.AmbientLighting.ColorHex': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.AmbientLighting.Brightness': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Cabin.AmbientLighting.AnimationMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.HeadUpDisplay.IsEnabled': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.HeadUpDisplay.Height': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Cabin.HeadUpDisplay.Mode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.Sentry.Mode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Cabin.Sentry.ThreatLevel': VssSignalMeta(type: VssNodeType.sensor, datatype: 'uint8'),
  'Vehicle.Cabin.ValetMode.IsEnabled': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.Glovebox.IsLocked': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Cabin.ConvertibleTop.Position': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', min: 0, max: 1),
  'Vehicle.Seat.Row1.Left.HeatingLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row1.Left.VentilationLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row1.Left.Massage.Mode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string', allowed: ['OFF', 'WAVE', 'PULSE', 'STRETCH'], defaultValue: 'OFF'),
  'Vehicle.Seat.Row1.Left.Massage.Intensity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row1.Left.MemoryProfile': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row1.Left.SideBolsterSupport': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Seat.Row1.Right.HeatingLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row1.Right.VentilationLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row1.Right.Massage.Mode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string', allowed: ['OFF', 'WAVE', 'PULSE', 'STRETCH'], defaultValue: 'OFF'),
  'Vehicle.Seat.Row1.Right.Massage.Intensity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row2.Left.ReclineAngle': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Seat.Row2.Left.HeatingLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row2.Left.VentilationLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row2.Left.Massage.Mode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string', allowed: ['OFF', 'WAVE', 'PULSE', 'STRETCH'], defaultValue: 'OFF'),
  'Vehicle.Seat.Row2.Left.Massage.Intensity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row2.Right.ReclineAngle': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Seat.Row2.Right.HeatingLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row2.Right.VentilationLevel': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Seat.Row2.Right.Massage.Mode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string', allowed: ['OFF', 'WAVE', 'PULSE', 'STRETCH'], defaultValue: 'OFF'),
  'Vehicle.Seat.Row2.Right.Massage.Intensity': VssSignalMeta(type: VssNodeType.actuator, datatype: 'uint8'),
  'Vehicle.Chassis.SteeringWheel.Angle': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float', unit: 'degrees', min: -540, max: 540, defaultValue: 0.0),
  'Vehicle.Chassis.SteeringWheel.Heated': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Chassis.RearAxleSteering.Angle': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Chassis.Suspension.Height': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string', allowed: ['LOW', 'NORMAL', 'HIGH', 'OFFROAD_MAX'], defaultValue: 'NORMAL'),
  'Vehicle.Chassis.Suspension.DampingMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Chassis.Suspension.AutoLeveling.Status': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Chassis.Brake.RegenMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Chassis.Axle.Row2.Differential.IsLocked': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Powertrain.TorqueSplit.RearPercent': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.StateOfCharge': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float', unit: 'percent', min: 0, max: 100, defaultValue: 80.0),
  'Vehicle.Powertrain.TractionBattery.Power': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.Temperature': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.Preconditioning.Status': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Powertrain.TractionBattery.Preconditioning.IsEnabled': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean', defaultValue: false),
  'Vehicle.Powertrain.TractionBattery.Charging.IsConnected': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Powertrain.TractionBattery.Charging.IsCharging': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean'),
  'Vehicle.Powertrain.TractionBattery.Charging.ChargePower': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.TractionBattery.Charging.TargetSoC': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float', unit: 'percent', min: 0, max: 100),
  'Vehicle.Powertrain.V2L.IsExportingPower': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Powertrain.CombustionEngine.Speed': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Powertrain.Transmission.SelectedGear': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string', allowed: ['PARK', 'REVERSE', 'NEUTRAL', 'DRIVE'], defaultValue: 'PARK'),
  'Vehicle.Body.Trunk.IsAjar': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean', defaultValue: false),
  'Vehicle.Body.Trunk.PowerOpeningAngle': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Body.Trailer.IsConnected': VssSignalMeta(type: VssNodeType.sensor, datatype: 'boolean'),
  'Vehicle.Body.Trailer.BrakeGain': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.Body.Lights.IsLeftIndicatorOn': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Body.Lights.IsRightIndicatorOn': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Body.Lights.IsHazardOn': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Body.Lights.MatrixBeamMode': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Media.ActiveSoundDesign': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.Media.ActiveNoiseCancellation': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.Media.SoundZoneBalance': VssSignalMeta(type: VssNodeType.actuator, datatype: 'string'),
  'Vehicle.ADAS.ACC.IsEngaged': VssSignalMeta(type: VssNodeType.actuator, datatype: 'boolean'),
  'Vehicle.ADAS.ACC.SetSpeed': VssSignalMeta(type: VssNodeType.actuator, datatype: 'float'),
  'Vehicle.ADAS.ObstacleDetection.LeadVehicle': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.ADAS.LaneKeepingAssist.Status': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.ADAS.LaneKeepingAssist.LeftLaneOffsetMeters': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.ADAS.LaneKeepingAssist.RightLaneOffsetMeters': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float'),
  'Vehicle.Software.OTA.Status': VssSignalMeta(type: VssNodeType.sensor, datatype: 'string'),
  'Vehicle.Exterior.AirTemperature': VssSignalMeta(type: VssNodeType.sensor, datatype: 'float', unit: 'celsius', min: -40, max: 60, defaultValue: 20.0),
};
