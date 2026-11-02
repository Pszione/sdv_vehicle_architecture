import 'dart:async';
import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../actuators/dumb_sunroof_actuator.dart';
import '../bus/zonal_command_bus.dart';
import '../domain/actuator_state.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_command.dart';
import '../domain/zonal_route.dart';
import '../hvac/cabin_thermal_model.dart';

part 'central_zone_controller.g.dart';

/// Central ECU: roof (sunroof), HVAC/thermal (cabin model + AUTO fan), the vehicle
/// mode manager (see `VehicleModeManager`) and the gateway to non-zonal domain ECUs
/// (powertrain, chassis, ADAS), which confirm the commanded value.
@Riverpod(keepAlive: true)
class CentralZoneController extends _$CentralZoneController {
  static const _thermalTick = Duration(seconds: 1);

  final _sunroof = DumbSunroofActuator(ZonalRoute.sunroof.deviceId);
  StreamSubscription<ActuatorPositionProgress>? _movement;
  Timer? _thermalTimer;

  @override
  void build() {
    final commands = ref.watch(zonalCommandBusProvider).commandsFor(VehicleZone.central).listen(_process);
    // A change outside also moves the cabin temperature.
    ref.listen(vssValueProvider(Vss.Vehicle.Exterior.AirTemperature), (_, _) => _startThermalModel());
    ref.onDispose(() {
      commands.cancel();
      _movement?.cancel();
      _thermalTimer?.cancel();
    });
  }

  /// Fault injection from the test panel/simulator.
  void injectSunroofFault(ActuatorFaultType fault) => _sunroof.injectFault(fault);

  VssBroker get _broker => ref.read(vssBrokerProvider.notifier);

  void _process(ZonalCommand command) {
    switch (command.deviceId) {
      case final id when id == ZonalRoute.sunroof.deviceId:
        _moveSunroof(command.command.value as int);
      case final id when id == ZonalRoute.vehicleModeManager.deviceId:
        return; // Executed by the VehicleModeManager, which listens to its own device.
      case final id when id == ZonalRoute.hvac.deviceId:
        _broker.publish(command.signal, command.command.value);
        _startThermalModel();
      default:
        _broker.publish(command.signal, command.command.value);
    }
  }

  void _moveSunroof(int targetPercent) {
    final position = Vss.Vehicle.Cabin.Sunroof.Position;
    // A new command replaces the movement in progress.
    _movement?.cancel();
    _movement = _sunroof.moveTo(targetPercent.toDouble()).listen((progress) {
      _broker.publish(position, progress.position.round());
      final isFaulted = progress.state == ActuatorState.stuck || progress.state == ActuatorState.fault;
      if (isFaulted) {
        developer.log('Actuator fault: ${progress.fault} at ${progress.position}', name: 'CentralZoneController');
      }
      // The broker ignores repeated values, so publishing every step causes no rebuilds.
      _broker.publish(Vss.Vehicle.Cabin.Sunroof.IsFaulted, isFaulted);
    });
  }

  /// Ticks the cabin model until the cabin temperature (and the AUTO fan) settle.
  void _startThermalModel() {
    if (!ref.read(isSignalSupportedProvider(Vss.Vehicle.Cabin.HVAC.AmbientAirTemperature))) return;
    _thermalTimer ??= Timer.periodic(_thermalTick, (_) {
      if (!_stepThermalModel()) {
        _thermalTimer?.cancel();
        _thermalTimer = null;
      }
    });
  }

  /// Returns whether the model is still moving.
  bool _stepThermalModel() {
    final values = SnapshotSignalReader(ref.read(vssBrokerProvider));
    final hvac = Vss.Vehicle.Cabin.HVAC;
    final stations = VehicleGroups.hvacStations;

    final cabin = values.read(hvac.AmbientAirTemperature) ?? 20.0;
    final outside = values.read(Vss.Vehicle.Exterior.AirTemperature) ?? cabin;
    final targets = [for (final s in stations) values.read(s.temperature) ?? 21.0];
    final target = targets.reduce((a, b) => a + b) / targets.length;

    if (values.read(hvac.IsAutoActive) ?? false) {
      final fan = CabinThermalModel.autoFanPercent(cabin: cabin, target: target);
      for (final station in stations) {
        _broker.publish(station.fanSpeed, fan);
      }
    }

    final fans = [for (final s in stations) values.read(s.fanSpeed) ?? 0];
    final fan = fans.reduce((a, b) => a > b ? a : b);
    final next = CabinThermalModel.step(cabin: cabin, target: target, outside: outside, fanPercent: fan);
    _broker.publish(hvac.AmbientAirTemperature, (next * 10).round() / 10);

    final goal = CabinThermalModel.equilibrium(isBlowing: fan > 0, target: target, outside: outside);
    return (next - goal).abs() >= CabinThermalModel.tolerance;
  }
}
