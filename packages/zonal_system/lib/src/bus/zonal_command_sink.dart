import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../domain/zonal_command.dart';
import '../domain/zonal_route.dart';
import 'zonal_command_bus.dart';

part 'zonal_command_sink.g.dart';

/// Connects the `CommandDispatcher` to the zonal bus, resolving each signal's route
/// for the current LHD/RHD layout.
final class ZonalCommandSink implements CommandSink {
  const ZonalCommandSink(this._bus, {required DriverSide Function() driverSide}) : _driverSide = driverSide;

  final ZonalCommandBus _bus;
  final DriverSide Function() _driverSide;

  @override
  void send(VehicleCommand<Object> command) {
    final route = ZonalRoute.of(command.signal, _driverSide());
    _bus.emit(ZonalCommand(targetZone: route.zone, deviceId: route.deviceId, command: command));
  }
}

/// [ZonalCommandSink] bound to the active profile. Apps use it to override `commandSinkProvider`.
@Riverpod(keepAlive: true)
ZonalCommandSink zonalCommandSink(Ref ref) => ZonalCommandSink(
  ref.watch(zonalCommandBusProvider),
  driverSide: () => ref.read(activeVehicleProfileProvider).driverSide,
);
