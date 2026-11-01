import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';

const _profile = VehicleProfile(
  id: 'test_forced',
  trimName: 'Test Forced',
  driverSide: DriverSide.left,
  supportedPaths: {'Vehicle.Speed', 'Vehicle.Chassis.Axle.Row2.Differential.IsLocked'},
);

void main() {
  test('should bypass the rules and log FORCED when forcing the diff lock at 100 km/h', () {
    final container = ProviderContainer.test(overrides: [initialVehicleProfileProvider.overrideWithValue(_profile)])
      ..read(vehicleLoggerProvider);
    final simulator = container.read(telemetrySimulatorProvider.notifier)..report(Vss.Vehicle.Speed, 100.0);
    final diffLock = Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked;

    final result = simulator.forceActuatorState(diffLock, true);

    expect(result, SignalWriteResult.accepted);
    expect(container.read(vssValueProvider(diffLock)), isTrue);
    expect(container.read(vehicleLoggerProvider).entries.map((e) => (e.type, e.vssPath)), [
      (LogType.forced, diffLock.path),
    ]);
  });
}
