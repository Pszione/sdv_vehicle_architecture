import 'package:build/build.dart';

import 'vss_spec.dart';

/// Gera, a partir de `*.vss.json`, um `part` com:
/// - a árvore tipada `Vss.Vehicle...`, onde cada folha é um `const VssSignal<T>`;
/// - o `vssCatalog`, com os metadados de cada sinal indexados pelo caminho.
///
/// O arquivo pai (configurado em `part_of`) precisa importar `VssSignal`,
/// `VssSignalMeta` e `VssNodeType`.
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
      ..writeln('// Fonte: $source (COVESA VSS)')
      ..writeln('// ignore_for_file: type=lint')
      ..writeln()
      ..writeln("part of '$partOf';")
      ..writeln()
      ..writeln('/// Raiz tipada da árvore VSS. Ex: `Vss.Vehicle.Cabin.Sunroof.Position`.')
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
      ..writeln('/// Metadados de todos os sinais do spec, indexados pelo caminho VSS.')
      ..writeln('const Map<String, VssSignalMeta> vssCatalog = {');
    for (final leaf in spec.leaves.values) {
      buffer.writeln("  '${leaf.path}': ${_meta(leaf)},");
    }
    buffer.writeln('};');
    return buffer.toString();
  }

  static void _writeBranch(StringBuffer buffer, VssBranch branch, Map<String, String> classNames) {
    final className = _className(branch);
    // Caminhos distintos não podem gerar o mesmo nome (ex: "A.BC" e "AB.C").
    final clash = classNames[className];
    if (clash != null) {
      throw FormatException('VSS spec inválido: "${branch.path}" e "$clash" geram a mesma classe $className.');
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
