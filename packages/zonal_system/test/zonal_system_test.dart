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

const _doorProfile = VehicleProfile(
  id: 'test_nm',
  trimName: 'Test NM',
  driverSide: DriverSide.left,
  supportedPaths: {'Vehicle.LowVoltageSystemState', 'Vehicle.Cabin.Door.Row1.DriverSide.IsLocked'},
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
      if (value == 10 && !reachedTarget.isCompleted) reachedTarget.complete();
    });

    container.read(commandDispatcherProvider.notifier).dispatch(VehicleCommand(signal: position, value: 10));

    await reachedTarget.future.timeout(const Duration(seconds: 5));
    expect(container.read(vssValueProvider(Vss.Vehicle.Cabin.Sunroof.IsFaulted)), isFalse);
  });

  test('should stop at half travel and report stuck when a mechanical jam is injected', () async {
    final sunroof = DumbSunroofActuator('SUNROOF_ACTUATOR')..injectFault(ActuatorFaultType.mechanicalJam);

    final last = await sunroof.moveTo(100, speedPerSecond: 250).last;

    expect(last.state, ActuatorState.stuck);
    expect(last.position, 50);
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

  test('should deliver a lock command to a sleeping zone only after the bus wake-up latency', () async {
    final container =
        ProviderContainer.test(
            overrides: [
              initialVehicleProfileProvider.overrideWithValue(_doorProfile),
              commandSinkProvider.overrideWith((ref) => ref.watch(zonalCommandSinkProvider)),
            ],
          )
          // Listen, not read: Riverpod 3 does not re-evaluate providers that nobody listens to.
          ..listen(zonalSystemProvider, (_, _) {});
    container.read(vssBrokerProvider.notifier).publish(Vss.Vehicle.LowVoltageSystemState, LowVoltageSystemState.lock);
    await container.pump(); // Riverpod 3 notifies the network management asynchronously.
    await Future<void>.delayed(ZoneNetworkManagement.prepareBusSleepTime * 2);
    final lock = VehicleGroups.driverDoor.lock;

    container.read(commandDispatcherProvider.notifier).dispatch(VehicleCommand(signal: lock, value: true));

    expect(container.read(vssValueProvider(lock)), isFalse);
    await Future<void>.delayed(ZoneNetworkManagement.wakeUpLatency * 2);
    expect(container.read(vssValueProvider(lock)), isTrue);
  });
}
