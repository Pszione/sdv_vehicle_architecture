import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../bus/zonal_command_bus.dart';
import '../domain/vehicle_zone.dart';
import '../modules/body_side_ecu.dart';

part 'east_zone_controller.g.dart';

/// East zone ECU: right-hand body (door locks, seats, window shades).
@Riverpod(keepAlive: true)
class EastZoneController extends _$EastZoneController {
  final _body = BodySideEcu();

  @override
  void build() {
    final commands = ref
        .watch(zonalCommandBusProvider)
        .commandsFor(VehicleZone.east)
        .listen((command) => _body.handle(command, ref.read(vssBrokerProvider.notifier)));
    ref.onDispose(commands.cancel);
  }
}
