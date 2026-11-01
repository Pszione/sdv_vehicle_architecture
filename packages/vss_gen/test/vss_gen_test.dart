import 'package:test/test.dart';
import 'package:vss_gen/src/vss_profile_builder.dart';
import 'package:vss_gen/src/vss_spec.dart';
import 'package:vss_gen/src/vss_tree_builder.dart';

const _spec = '''
{
  "Vehicle": {
    "type": "branch",
    "children": {
      "Speed": { "type": "sensor", "datatype": "float", "min": 0, "max": 300 },
      "Cabin": {
        "type": "branch",
        "children": {
          "Door": { "type": "branch", "children": {
            "Row1": { "type": "branch", "children": {
              "IsLocked": { "type": "actuator", "datatype": "boolean" } } } } },
          "HVAC": { "type": "branch", "children": {
            "Row1": { "type": "branch", "children": {
              "FanSpeed": { "type": "actuator", "datatype": "uint8" } } } } }
        }
      }
    }
  }
}
''';

void main() {
  test('should generate distinct typed classes when branch names repeat across parents', () {
    final code = VssTreeBuilder.generate(VssSpec.parse(_spec), partOf: 'vss.dart', source: 'test.vss.json');

    expect(code, contains('final class _VssVehicleCabinDoorRow1 {'));
    expect(code, contains('final class _VssVehicleCabinHVACRow1 {'));
    expect(
      code,
      contains("VssSignal<bool> get IsLocked => const VssSignal<bool>('Vehicle.Cabin.Door.Row1.IsLocked');"),
    );
    expect(code, contains("VssSignal<int> get FanSpeed => const VssSignal<int>('Vehicle.Cabin.HVAC.Row1.FanSpeed');"));
  });

  test('should fail the build when a profile references a signal missing from the spec', () {
    final profile = {
      'id': 'entry',
      'trimName': 'Entry',
      'driverSide': 'left',
      'signals': ['Vehicle.Speed', 'Vehicle.Cabin.Sunroof.Position'],
    };

    expect(
      () => VssProfileBuilder.generate(VssSpec.parse(_spec), profile, partOf: 'p.dart', source: 'entry.profile.json'),
      throwsA(isA<FormatException>().having((e) => e.message, 'message', contains('Vehicle.Cabin.Sunroof.Position'))),
    );
  });
}
