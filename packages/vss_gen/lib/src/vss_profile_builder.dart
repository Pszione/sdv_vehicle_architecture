import 'dart:convert';

import 'package:build/build.dart';

import 'vss_spec.dart';

/// Gera, a partir de `*.profile.json`, um `part` com um `const VehicleProfile`.
///
/// O perfil é validado contra o spec mestre ([specUri]) durante o build:
/// caminho inexistente, override inválido ou campo faltando derrubam o build.
class VssProfileBuilder implements Builder {
  VssProfileBuilder({required this.specUri, required this.partOf});

  /// URI `package:` do spec mestre (ex: `package:vehicle_domain/src/vss/vehicle.vss.json`).
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
      throw StateError('Spec VSS não encontrado em "$specUri" (opção "spec" do vss_profile).');
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
    if (profile is! Map<String, Object?>) _fail(source, 'o perfil deve ser um objeto JSON.');
    final id = profile['id'];
    final trimName = profile['trimName'];
    final driverSide = profile['driverSide'];
    final signals = profile['signals'];
    final overrides = profile['overrides'] ?? const <String, Object?>{};

    if (id is! String || !RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(id)) _fail(source, '"id" deve ser snake_case.');
    if (trimName is! String || trimName.isEmpty) _fail(source, '"trimName" é obrigatório.');
    if (!_driverSides.contains(driverSide)) _fail(source, '"driverSide" deve ser ${_driverSides.join(' ou ')}.');
    if (signals is! List || signals.isEmpty) _fail(source, '"signals" deve ser uma lista não vazia.');
    if (overrides is! Map<String, Object?>) _fail(source, '"overrides" deve ser um objeto.');

    final paths = <String>{};
    for (final path in signals) {
      if (path is! String || !spec.leaves.containsKey(path)) _fail(source, 'sinal "$path" não existe no spec VSS.');
      if (!paths.add(path)) _fail(source, 'sinal "$path" duplicado.');
    }

    final overrideArgs = <String, String>{};
    for (final MapEntry(key: path, value: fields) in overrides.entries) {
      if (!paths.contains(path)) _fail(source, 'override de "$path", que não está em "signals".');
      if (fields is! Map<String, Object?> || fields.isEmpty) _fail(source, 'override de "$path" deve ser um objeto.');
      final unknown = fields.keys.toSet().difference(_overridableFields);
      if (unknown.isNotEmpty) _fail(source, 'override de "$path" só aceita ${_overridableFields.join(', ')}.');
      final leaf = spec.leaves[path]!;
      if ((fields.containsKey('min') || fields.containsKey('max')) && !leaf.isNumeric) {
        _fail(source, 'override de "$path": min/max só valem para sinais numéricos.');
      }
      overrideArgs[path] = [
        for (final field in _overridableFields)
          if (fields[field] case final value?) '$field: ${dartLiteral(value)}',
      ].join(', ');
    }

    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// Fonte: $source')
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

  static Never _fail(String source, String message) => throw FormatException('Perfil inválido ($source): $message');
}
