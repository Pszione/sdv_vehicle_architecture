import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

void main() {
  test('should reject the OTA install when someone is seated inside the parked car', () {
    final signals = SnapshotSignalReader({
      Vss.Vehicle.Powertrain.Transmission.SelectedGear.path: Gear.park,
      Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge.path: 80.0,
      for (final door in VehicleGroups.doors) door.lock.path: true,
      Vss.Vehicle.Cabin.Seat.Row2.PassengerSide.OccupancyStatus.path: SeatOccupancy.occupied,
    });

    final result = OtaInstallSafetyRule().validate(
      VehicleCommand(signal: Vss.Vehicle.Software.OTA.IsInstalling, value: true),
      signals,
    );

    expect(result?.status, CommandStatus.rejectedBySafetyRule);
    expect(result?.message, contains('Rear passenger side seat is occupied'));
  });
}
