import 'dart:convert';

import 'package:build/build.dart';

import 'vss_spec.dart';

/// Generates, from `*.profile.json`, a `part` file with a `const VehicleProfile`.
///
/// The profile is validated against the master spec ([specUri]) at build time:
/// an unknown path, an invalid override or a missing field fails the build.
class VssProfileBuilder implements Builder {
  VssProfileBuilder({required this.specUri, required this.partOf});

  /// `package:` URI of the master spec (e.g. `package:vehicle_domain/src/vss/vehicle.vss.json`).
  final String specUri;
  final String partOf;

  static const _overridableFields = {'min', 'max', 'allowed'};
  static const _driverSides = {'left', 'right'};

  @override
  final buildExtensions = const {
    '.profile.json': ['.profile.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final specId = AssetId.resolve(Uri.parse(specUri));
    if (!await buildStep.canRead(specId)) {
      throw StateError('VSS spec not found at "$specUri" (vss_profile "spec" option).');
    }
    final spec = VssSpec.parse(await buildStep.readAsString(specId));
    final profile = jsonDecode(await buildStep.readAsString(buildStep.inputId));
    final output = buildStep.inputId.changeExtension('').changeExtension('.profile.g.dart');
    await buildStep.writeAsString(
      output,
      generate(spec, profile, partOf: partOf, source: buildStep.inputId.pathSegments.last),
    );
  }

  static String generate(VssSpec spec, Object? profile, {required String partOf, required String source}) {
    if (profile is! Map<String, Object?>) _fail(source, 'the profile must be a JSON object.');
    final id = profile['id'];
    final trimName = profile['trimName'];
    final driverSide = profile['driverSide'];
    final signals = profile['signals'];
    final overrides = profile['overrides'] ?? const <String, Object?>{};

    if (id is! String || !RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(id)) _fail(source, '"id" must be snake_case.');
    if (trimName is! String || trimName.isEmpty) _fail(source, '"trimName" is required.');
    if (!_driverSides.contains(driverSide)) _fail(source, '"driverSide" must be ${_driverSides.join(' or ')}.');
    if (signals is! List || signals.isEmpty) _fail(source, '"signals" must be a non-empty list.');
    if (overrides is! Map<String, Object?>) _fail(source, '"overrides" must be an object.');

    final paths = <String>{};
    for (final path in signals) {
      if (path is! String || !spec.leaves.containsKey(path))
        _fail(source, 'signal "$path" does not exist in the VSS spec.');
      if (!paths.add(path)) _fail(source, 'duplicated signal "$path".');
    }

    final overrideArgs = <String, String>{};
    for (final MapEntry(key: path, value: fields) in overrides.entries) {
      if (!paths.contains(path)) _fail(source, 'override for "$path", which is not listed in "signals".');
      if (fields is! Map<String, Object?> || fields.isEmpty) _fail(source, 'override for "$path" must be an object.');
      final unknown = fields.keys.toSet().difference(_overridableFields);
      if (unknown.isNotEmpty) _fail(source, 'override for "$path" only accepts ${_overridableFields.join(', ')}.');
      final leaf = spec.leaves[path]!;
      if ((fields.containsKey('min') || fields.containsKey('max')) && !leaf.isNumeric) {
        _fail(source, 'override for "$path": min/max only apply to numeric signals.');
      }
      overrideArgs[path] = [
        for (final field in _overridableFields)
          if (fields[field] case final value?) '$field: ${dartLiteral(value)}',
      ].join(', ');
    }

    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// Source: $source')
      ..writeln('// ignore_for_file: type=lint')
      ..writeln()
      ..writeln("part of '$partOf';")
      ..writeln()
      ..writeln('/// $trimName')
      ..writeln('const ${_constName(id)} = VehicleProfile(')
      ..writeln("  id: '$id',")
      ..writeln('  trimName: ${dartLiteral(trimName)},')
      ..writeln('  driverSide: DriverSide.$driverSide,')
      ..writeln('  supportedPaths: {');
    for (final path in paths) {
      buffer.writeln("    '$path',");
    }
    buffer.writeln('  },');
    if (overrideArgs.isNotEmpty) {
      buffer.writeln('  overrides: {');
      overrideArgs.forEach((path, args) => buffer.writeln("    '$path': VssMetaOverride($args),"));
      buffer.writeln('  },');
    }
    buffer.writeln(');');
    return buffer.toString();
  }

  /// `luxury_ev_suv` -> `luxuryEvSuvProfile`.
  static String _constName(String id) {
    final [first, ...rest] = id.split('_');
    return '$first${rest.map((p) => p[0].toUpperCase() + p.substring(1)).join()}Profile';
  }

  static Never _fail(String source, String message) => throw FormatException('Invalid profile ($source): $message');
}
