import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

final class _RecordingSink implements CommandSink {
  final sent = <VehicleCommand<Object>>[];

  @override
  void send(VehicleCommand<Object> command) => sent.add(command);
}

const _profile = VehicleProfile(
  id: 'test_e2e',
  trimName: 'Test E2E',
  driverSide: DriverSide.left,
  supportedPaths: {'Vehicle.Speed', 'Vehicle.Body.Trunk.Rear.IsOpen'},
);

void main() {
  group('E2E check', () {
    test('should go INVALID when a frozen sender repeats its frame and recover after a clean window', () {
      final sender = E2eProtector(0x101);
      final checker = E2eChecker(0x101);
      final stateMachine = E2eStateMachine();
      E2eSmState receive(E2eFrame frame) => stateMachine.update(checker.check(frame));

      expect(receive(sender.protect(50.0)), E2eSmState.valid);
      final frozen = sender.protect(50.0);
      receive(frozen);
      receive(frozen);
      expect(receive(frozen), E2eSmState.invalid);

      for (var i = 0; i < E2eStateMachine.windowSize - 1; i++) {
        receive(sender.protect(50.0));
      }
      expect(receive(sender.protect(50.0)), E2eSmState.valid);
    });

    test('should report a CRC error when a single bit of the payload flips', () {
      final frame = E2eProtector(0x101).protect(50.0);

      final corrupted = E2eFrame(counter: frame.counter, crc: frame.crc, payload: 50.000000000000014);

      expect(E2eChecker(0x101).check(corrupted), E2eCheckStatus.error);
    });
  });

  test('should reject opening the tailgate when the speed signal went stale', () async {
    final sink = _RecordingSink();
    final container = ProviderContainer.test(
      overrides: [
        initialVehicleProfileProvider.overrideWithValue(_profile),
        commandSinkProvider.overrideWithValue(sink),
      ],
    )..listen(e2eReceiverProvider, (_, _) {});
    container.read(e2eReceiverProvider.notifier)
      ..startDeadlineMonitoring()
      ..receive(Vss.Vehicle.Speed, E2eProtector(0x101).protect(0.0));

    await Future<void>.delayed(E2eProtectedSignals.timeout * 2);
    final result = container
        .read(commandDispatcherProvider.notifier)
        .dispatch(VehicleCommand(signal: Vss.Vehicle.Body.Trunk.Rear.IsOpen, value: true));

    expect(container.read(signalStatusProvider(Vss.Vehicle.Speed)), SignalStatus.stale);
    expect(result, FailSafe.speedUnavailable);
    expect(sink.sent, isEmpty);
  });
}
