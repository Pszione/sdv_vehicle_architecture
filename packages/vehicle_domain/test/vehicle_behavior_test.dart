import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Captures what the dispatcher sends to the zonal bus.
final class _RecordingSink implements CommandSink {
  final sent = <VehicleCommand<Object>>[];

  @override
  void send(VehicleCommand<Object> command) => sent.add(command);
}

final _profile = VehicleProfile(
  id: 'test_behaviors',
  trimName: 'Test Behaviors',
  driverSide: DriverSide.left,
  supportedPaths: {
    'Vehicle.Speed',
    'Vehicle.Chassis.Axle.Row2.Differential.IsLocked',
    'Vehicle.ADAS.ESC.Mode',
    for (final door in VehicleGroups.doors) ...[door.lock.path, door.open.path],
    for (final station in VehicleGroups.hvacStations) station.temperature.path,
    'Vehicle.Cabin.HVAC.IsSyncActive',
  },
);

void main() {
  late _RecordingSink sink;
  late ProviderContainer container;

  setUp(() {
    sink = _RecordingSink();
    container = ProviderContainer.test(
      overrides: [
        initialVehicleProfileProvider.overrideWithValue(_profile),
        commandSinkProvider.overrideWithValue(sink),
      ],
    )..read(vehicleBehaviorEngineProvider);
  });

  Future<void> publish<T extends Object>(VssSignal<T> signal, T value) async {
    container.read(vssBrokerProvider.notifier).publish(signal, value);
    await Future<void>.delayed(Duration.zero); // behaviors dispatch on the next cycle
  }

  test('should lock every unlocked door when speed crosses 15 km/h', () async {
    await publish(Vss.Vehicle.Speed, 20.0);

    expect(sink.sent.map((c) => (c.signal, c.value, c.source)), [
      for (final door in VehicleGroups.doors) (door.lock, true, SpeedAutoLockBehavior.source),
    ]);
  });

  test('should turn ESC off when the rear diff lock is confirmed', () async {
    await publish(Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked, true);

    expect(sink.sent, [
      VehicleCommand(signal: Vss.Vehicle.ADAS.ESC.Mode, value: EscMode.off, source: DiffLockEscBehavior.source),
    ]);
  });

  test('should make passenger and rear zones follow the driver temperature when SYNC is on', () async {
    final [driver, ...others] = VehicleGroups.hvacStations;
    await publish(Vss.Vehicle.Cabin.HVAC.IsSyncActive, true);

    await publish(driver.temperature, 24.0);

    expect(sink.sent, [
      for (final station in others)
        VehicleCommand(signal: station.temperature, value: 24.0, source: ClimateSyncBehavior.source),
    ]);
  });
}
