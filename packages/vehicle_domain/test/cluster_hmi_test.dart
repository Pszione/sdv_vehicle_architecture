import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

void main() {
  test('should flash the seatbelt telltale when the driver is unbelted above 25 km/h', () {
    SignalReader reader(double speedKmh) => SnapshotSignalReader({
      VehicleGroups.driverSeat.occupancy.path: SeatOccupancy.occupied,
      VehicleGroups.driverSeat.belted.path: false,
      Vss.Vehicle.Speed.path: speedKmh,
    });

    expect(TelltaleLogic.evaluate(Telltale.seatbelt, reader(10)), TelltaleState.on);
    expect(TelltaleLogic.evaluate(Telltale.seatbelt, reader(40)), TelltaleState.flashing);
  });

  test('should keep a warning ahead of newer information and replace a message with the same id', () {
    const warning = DriverMessage(id: 'rejected:x', text: 'Rejected', severity: DriverMessageSeverity.warning);
    const info = DriverMessage(id: 'power', text: 'Ready to drive', severity: DriverMessageSeverity.info);
    const newerInfo = DriverMessage(id: 'power', text: 'Charging', severity: DriverMessageSeverity.info);

    final queue = const DriverMessageQueue().post(warning).post(info).post(newerInfo);

    expect(queue.messages, [warning, newerInfo]);
  });
}
