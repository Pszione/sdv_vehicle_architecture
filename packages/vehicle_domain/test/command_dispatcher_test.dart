import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Captura o que o dispatcher envia ao barramento zonal.
final class _RecordingSink implements CommandSink {
  final sent = <VehicleCommand<Object>>[];

  @override
  void send(VehicleCommand<Object> command) => sent.add(command);
}

const _offroadProfile = VehicleProfile(
  id: 'test_offroad',
  trimName: 'Test Offroad',
  driverSide: DriverSide.left,
  supportedPaths: {
    'Vehicle.Speed',
    'Vehicle.Chassis.SteeringWheel.Angle',
    'Vehicle.Chassis.Axle.Row2.Differential.IsLocked',
  },
);

void main() {
  late _RecordingSink sink;
  late ProviderContainer container;
  final diffLock = VehicleCommand(signal: Vss.Vehicle.Chassis.Axle.Row2.Differential.IsLocked, value: true);

  setUp(() {
    sink = _RecordingSink();
    container = ProviderContainer.test(
      overrides: [
        initialVehicleProfileProvider.overrideWithValue(_offroadProfile),
        commandSinkProvider.overrideWithValue(sink),
      ],
    );
  });

  void reportSpeed(double kmh) => container.read(vssBrokerProvider.notifier).publish(Vss.Vehicle.Speed, kmh);
  CommandResult dispatch(VehicleCommand<Object> command) =>
      container.read(commandDispatcherProvider.notifier).dispatch(command);

  test('should reject diff lock and keep it off the zonal bus when speed is above 30 km/h', () {
    reportSpeed(45);

    final result = dispatch(diffLock);

    expect(result.status, CommandStatus.rejectedBySafetyRule);
    expect(sink.sent, isEmpty);
  });

  test('should send diff lock to the sink when speed and steering are within limits', () {
    reportSpeed(10);

    final result = dispatch(diffLock);

    expect(result.status, CommandStatus.approved);
    expect(sink.sent, [diffLock]);
  });

  test('should return notSupported when the profile does not have the signal', () {
    final result = dispatch(VehicleCommand(signal: Vss.Vehicle.Cabin.Sunroof.Position, value: 50));

    expect(result.status, CommandStatus.notSupportedByVehicle);
    expect(sink.sent, isEmpty);
  });

  test('should re-evaluate canDispatch when a rule input changes', () async {
    final results = <CommandStatus>[];
    container.listen(canDispatchProvider(diffLock), (_, next) => results.add(next.status), fireImmediately: true);

    reportSpeed(45);
    await container.pump();

    expect(results, [CommandStatus.approved, CommandStatus.rejectedBySafetyRule]);
  });
}
