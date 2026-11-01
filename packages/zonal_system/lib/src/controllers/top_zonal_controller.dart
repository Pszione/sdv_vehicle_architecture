import 'dart:async';
import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../actuators/dumb_sunroof_actuator.dart';
import '../bus/zonal_command_bus.dart';
import '../domain/actuator_state.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_command.dart';

part 'top_zonal_controller.g.dart';

/// Top zone ECU: sunroof.
@Riverpod(keepAlive: true)
class TopZoneController extends _$TopZoneController {
  final _sunroof = DumbSunroofActuator('SUNROOF_ACTUATOR');
  StreamSubscription<ActuatorPositionProgress>? _movement;

  @override
  void build() {
    final commands = ref.watch(zonalCommandBusProvider).commandsFor(VehicleZone.top).listen(_process);
    ref.onDispose(() {
      commands.cancel();
      _movement?.cancel();
    });
  }

  /// Fault injection from the test panel/simulator.
  void injectSunroofFault(ActuatorFaultType fault) => _sunroof.injectFault(fault);

  void _process(ZonalCommand command) {
    final position = Vss.Vehicle.Cabin.Sunroof.Position;
    if (command.deviceId != _sunroof.id || command.signal != position) return;

    // A new command replaces the movement in progress.
    _movement?.cancel();
    _movement = _sunroof.moveTo(command.command.value as double).listen((progress) {
      final broker = ref.read(vssBrokerProvider.notifier);
      broker.publish(position, progress.position);

      final isFaulted = progress.state == ActuatorState.stuck || progress.state == ActuatorState.fault;
      if (isFaulted) {
        developer.log('Actuator fault: ${progress.fault} at ${progress.position}', name: 'TopZoneController');
      }
      // The broker ignores repeated values, so publishing every step causes no rebuilds.
      broker.publish(Vss.Vehicle.Cabin.Sunroof.IsFaulted, isFaulted);
    });
  }
}
