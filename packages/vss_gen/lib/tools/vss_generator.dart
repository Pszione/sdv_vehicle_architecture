import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';

Builder vssTreeBuilder(BuilderOptions options) => VssTreeBuilder();

class VssTreeBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.json': ['.vss.g.dart']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Processa apenas o arquivo vss_spec.json
    if (!buildStep.inputId.path.endsWith('vss_spec.json')) return;

    final content = await buildStep.readAsString(buildStep.inputId);
    final Map<String, dynamic> json = jsonDecode(content);

    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// Generated from VSS JSON Specification\n');
    buffer.writeln('abstract class Vss {');

    // Inicia a geração recursiva da árvore
    final rootKey = json.keys.first;
    final className = '_Vss$rootKey';

    buffer.writeln('  static const $rootKey = $className(\'$rootKey\');');
    buffer.writeln('}\n');

    _generateNodeClass(buffer, rootKey, json[rootKey] as Map<String, dynamic>);

    final outputId = buildStep.inputId.changeExtension('.vss.g.dart');
    await buildStep.writeAsString(outputId, buffer.toString());
  }

  void _generateNodeClass(StringBuffer buffer, String name, Map<String, dynamic> node) {
    final className = '_Vss$name';
    buffer.writeln('class $className {');
    buffer.writeln('  final String path;');
    buffer.writeln('  const $className(this.path);\n');

    final childClassesToGenerate = <String, Map<String, dynamic>>{};

    node.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        if (value.containsKey('datatype')) {
          // É uma folha/sinal
          buffer.writeln('  String get $key => \'\$path.$key\';');
        } else {
          // É um nó/ramo hierárquico
          final childClassName = '_Vss$key';
          buffer.writeln('  $childClassName get $key => $childClassName(\'\$path.$key\');');
          childClassesToGenerate[key] = value;
        }
      }
    });

    buffer.writeln('}\n');

    // Gera recursivamente os nós filhos
    childClassesToGenerate.forEach((childName, childNode) {
      _generateNodeClass(buffer, childName, childNode);
    });
  }
}