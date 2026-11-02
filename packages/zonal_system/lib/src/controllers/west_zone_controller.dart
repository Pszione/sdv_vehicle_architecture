import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../bus/zonal_command_bus.dart';
import '../domain/vehicle_zone.dart';
import '../modules/body_side_ecu.dart';

part 'west_zone_controller.g.dart';

/// West zone ECU: left-hand body (door locks, seats, window shades).
@Riverpod(keepAlive: true)
class WestZoneController extends _$WestZoneController {
  final _body = BodySideEcu();

  @override
  void build() {
    final commands = ref
        .watch(zonalCommandBusProvider)
        .commandsFor(VehicleZone.west)
        .listen((command) => _body.handle(command, ref.read(vssBrokerProvider.notifier)));
    ref.onDispose(commands.cancel);
  }
}
