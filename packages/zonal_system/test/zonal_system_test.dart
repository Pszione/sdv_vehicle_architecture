import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:zonal_system/zonal_system.dart';

const _sunroofProfile = VehicleProfile(
  id: 'test_sunroof',
  trimName: 'Test Sunroof',
  driverSide: DriverSide.left,
  supportedPaths: {'Vehicle.Speed', 'Vehicle.Cabin.Sunroof.Position', 'Vehicle.Cabin.Sunroof.IsFaulted'},
);

void main() {
  test('should confirm the sunroof position in the broker when a command goes through the central zone', () async {
    final container = ProviderContainer.test(
      overrides: [
        initialVehicleProfileProvider.overrideWithValue(_sunroofProfile),
        commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
      ],
    );
    container.read(zonalSystemProvider);
    final position = Vss.Vehicle.Cabin.Sunroof.Position;
    final reachedTarget = Completer<void>();
    container.listen(vssValueProvider(position), (_, value) {
      if (value == 0.1 && !reachedTarget.isCompleted) reachedTarget.complete();
    });

    container.read(commandDispatcherProvider.notifier).dispatch(VehicleCommand(signal: position, value: 0.1));

    await reachedTarget.future.timeout(const Duration(seconds: 5));
    expect(container.read(vssValueProvider(Vss.Vehicle.Cabin.Sunroof.IsFaulted)), isFalse);
  });

  test('should stop at half travel and report stuck when a mechanical jam is injected', () async {
    final sunroof = DumbSunroofActuator('SUNROOF_ACTUATOR')..injectFault(ActuatorFaultType.mechanicalJam);

    final last = await sunroof.moveTo(1.0, speedPerSecond: 2.5).last;

    expect(last.state, ActuatorState.stuck);
    expect(last.position, 0.5);
    expect(last.fault, ActuatorFaultType.mechanicalJam);
  });

  test('should move the cabin temperature toward the target faster with a higher fan speed', () {
    double after10s(int fan) {
      var cabin = 30.0;
      for (var i = 0; i < 10; i++) {
        cabin = CabinThermalModel.step(cabin: cabin, target: 21, outside: 30, fanPercent: fan);
      }
      return cabin;
    }

    expect(after10s(100), lessThan(after10s(20)));
    expect(after10s(20), lessThan(30));
  });
}
