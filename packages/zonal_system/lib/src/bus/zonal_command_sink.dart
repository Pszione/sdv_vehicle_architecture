import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../domain/zonal_command.dart';
import '../domain/vehicle_zone.dart';
import '../domain/zonal_route.dart';
import '../power/zone_network_management.dart';
import 'zonal_command_bus.dart';

part 'zonal_command_sink.g.dart';

/// Connects the `CommandDispatcher` to the zonal bus, resolving each signal's route
/// for the current LHD/RHD layout.
///
/// A command to a sleeping zone wakes it first ([wakeZone]) and is delivered once the
/// zone's bus is up, as with a CAN wake-up frame.
final class ZonalCommandSink implements CommandSink {
  const ZonalCommandSink(
    this._bus, {
    required DriverSide Function() driverSide,
    Duration Function(VehicleZone zone)? wakeZone,
  }) : _driverSide = driverSide,
       _wakeZone = wakeZone;

  final ZonalCommandBus _bus;
  final DriverSide Function() _driverSide;
  final Duration Function(VehicleZone zone)? _wakeZone;

  @override
  void send(VehicleCommand<Object> command) {
    final route = ZonalRoute.of(command.signal, _driverSide());
    final frame = ZonalCommand(targetZone: route.zone, deviceId: route.deviceId, command: command);
    final wakeUpLatency = _wakeZone?.call(route.zone) ?? Duration.zero;
    if (wakeUpLatency == Duration.zero) return _bus.emit(frame);
    Timer(wakeUpLatency, () => _bus.emit(frame));
  }
}

/// [ZonalCommandSink] bound to the active profile. Apps use it to override `commandSinkProvider`.
@Riverpod(keepAlive: true)
ZonalCommandSink zonalCommandSink(Ref ref) => ZonalCommandSink(
  ref.watch(zonalCommandBusProvider),
  driverSide: () => ref.read(activeVehicleProfileProvider).driverSide,
  wakeZone: (zone) => ref.read(zoneNetworkManagementProvider.notifier).requestWake(zone),
);
