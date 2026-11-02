import 'package:test/test.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

void main() {
  test('should cap the fan at 50% when the battery is below 10%', () {
    final fan = VehicleGroups.hvacStations.first.fanSpeed;
    final rule = ClimateRangeProtectionSafetyRule(fan);
    final lowBattery = SnapshotSignalReader({Vss.Vehicle.Powertrain.TractionBattery.StateOfCharge.path: 8.0});

    expect(rule.validate(VehicleCommand(signal: fan, value: 50), lowBattery), isNull);
    expect(
      rule.validate(VehicleCommand(signal: fan, value: 80), lowBattery)?.status,
      CommandStatus.rejectedBySafetyRule,
    );
  });
}
