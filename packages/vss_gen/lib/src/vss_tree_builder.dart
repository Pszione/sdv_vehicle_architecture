import 'package:build/build.dart';

import 'vss_spec.dart';

/// Generates, from `*.vss.json`, a `part` file containing:
/// - the typed `Vss.Vehicle...` tree, where every leaf is a `const VssSignal<T>`;
/// - `vssCatalog`, the metadata of every signal keyed by its path.
///
/// The parent library (configured by `part_of`) must import `VssSignal`,
/// `VssSignalMeta` and `VssNodeType`.
class VssTreeBuilder implements Builder {
  VssTreeBuilder({required this.partOf});

  final String partOf;

  @override
  final buildExtensions = const {
    '.vss.json': ['.vss.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final spec = VssSpec.parse(await buildStep.readAsString(buildStep.inputId));
    final output = buildStep.inputId.changeExtension('').changeExtension('.vss.g.dart');
    await buildStep.writeAsString(output, generate(spec, partOf: partOf, source: buildStep.inputId.pathSegments.last));
  }

  static String generate(VssSpec spec, {required String partOf, required String source}) {
    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// Source: $source (COVESA VSS)')
      ..writeln('// ignore_for_file: type=lint')
      ..writeln()
      ..writeln("part of '$partOf';")
      ..writeln()
      ..writeln('/// Typed root of the VSS tree, e.g. `Vss.Vehicle.Cabin.Sunroof.Position`.')
      ..writeln('abstract final class Vss {');
    for (final root in spec.roots) {
      buffer.writeln('  static const ${root.name} = ${_className(root)}();');
    }
    buffer.writeln('}');

    final classNames = <String, String>{};
    for (final root in spec.roots) {
      _writeBranch(buffer, root, classNames);
    }

    buffer
      ..writeln()
      ..writeln('/// Metadata of every signal in the spec, keyed by VSS path.')
      ..writeln('const Map<String, VssSignalMeta> vssCatalog = {');
    for (final leaf in spec.leaves.values) {
      buffer.writeln("  '${leaf.path}': ${_meta(leaf)},");
    }
    buffer.writeln('};');
    return buffer.toString();
  }

  static void _writeBranch(StringBuffer buffer, VssBranch branch, Map<String, String> classNames) {
    final className = _className(branch);
    // Distinct paths must not produce the same name (e.g. "A.BC" and "AB.C").
    final clash = classNames[className];
    if (clash != null) {
      throw FormatException('Invalid VSS spec: "${branch.path}" and "$clash" both generate class $className.');
    }
    classNames[className] = branch.path;

    buffer
      ..writeln()
      ..writeln('final class $className {')
      ..writeln('  const $className();');
    for (final child in branch.children) {
      buffer.writeln();
      if (child.description case final description?) buffer.writeln('  /// $description');
      switch (child) {
        case VssLeaf():
          buffer.writeln(
            "  VssSignal<${child.dartType}> get ${child.name} => const VssSignal<${child.dartType}>('${child.path}');",
          );
        case VssBranch():
          buffer.writeln('  ${_className(child)} get ${child.name} => const ${_className(child)}();');
      }
    }
    buffer.writeln('}');

    for (final child in branch.children.whereType<VssBranch>()) {
      _writeBranch(buffer, child, classNames);
    }
  }

  static String _className(VssBranch branch) => '_Vss${branch.path.replaceAll('.', '')}';

  static String _meta(VssLeaf leaf) {
    final args = [
      'type: VssNodeType.${leaf.type}',
      "datatype: '${leaf.datatype}'",
      if (leaf.unit != null) 'unit: ${dartLiteral(leaf.unit)}',
      if (leaf.min != null) 'min: ${leaf.min}',
      if (leaf.max != null) 'max: ${leaf.max}',
      if (leaf.allowed != null) 'allowed: ${dartLiteral(leaf.allowed)}',
      if (leaf.defaultValue != null) 'defaultValue: ${dartLiteral(leaf.defaultValue, dartType: leaf.dartType)}',
    ];
    return 'VssSignalMeta(${args.join(', ')})';
  }
}
