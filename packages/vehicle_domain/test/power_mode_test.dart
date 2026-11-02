import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

final class _RecordingSink implements CommandSink {
  final sent = <VehicleCommand<Object>>[];

  @override
  void send(VehicleCommand<Object> command) => sent.add(command);
}

const _profile = VehicleProfile(
  id: 'test_power',
  trimName: 'Test Power',
  driverSide: DriverSide.left,
  supportedPaths: {
    'Vehicle.LowVoltageSystemState',
    'Vehicle.PowerMode.Request',
    'Vehicle.Body.Keyless.KeyLocation',
    'Vehicle.Chassis.Brake.PedalPosition',
    'Vehicle.Powertrain.TractionBattery.IsPowerConnected',
    'Vehicle.Powertrain.TractionBattery.Charging.IsConnected',
    'Vehicle.ADAS.CruiseControl.IsActive',
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
    );
  });

  CommandResult dispatch<T extends Object>(VssSignal<T> signal, T value) =>
      container.read(commandDispatcherProvider.notifier).dispatch(VehicleCommand(signal: signal, value: value));

  test('should reject cruise control with a READY hint when the vehicle is only ON', () {
    final result = dispatch(Vss.Vehicle.ADAS.CruiseControl.IsActive, true);

    expect(result.status, CommandStatus.unavailableInPowerMode);
    expect(result.message, 'Available when the vehicle is READY.');
    expect(sink.sent, isEmpty);
  });

  test('should reject READY when the charging cable is connected, even with the brake pressed', () {
    container.read(vssBrokerProvider.notifier)
      ..publish(Vss.Vehicle.Chassis.Brake.PedalPosition, 100)
      ..publish(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsConnected, true);

    final result = dispatch(Vss.Vehicle.PowerMode.Request, PowerModeRequest.ready);

    expect(result, const CommandResult.rejected('Unplug the charging cable to drive.'));
    expect(sink.sent, isEmpty);
  });
}
