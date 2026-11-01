import 'dart:convert';

/// Modelo em memória de um spec VSS no formato JSON exportado pelo vss-tools
/// (`type`, `children`, `datatype`, `min`, `max`, `unit`, `allowed`, `default`).
///
/// Toda inconsistência vira [FormatException], o que faz o build falhar em vez
/// de gerar uma API parcialmente errada.
sealed class VssNode {
  VssNode(this.name, this.path, this.description);

  final String name;
  final String path;
  final String? description;
}

final class VssBranch extends VssNode {
  VssBranch(super.name, super.path, super.description, this.children);

  final List<VssNode> children;
}

final class VssLeaf extends VssNode {
  VssLeaf(
    super.name,
    super.path,
    super.description, {
    required this.type,
    required this.datatype,
    required this.dartType,
    this.unit,
    this.min,
    this.max,
    this.allowed,
    this.defaultValue,
  });

  /// `sensor`, `actuator` ou `attribute`.
  final String type;

  /// Datatype VSS original (ex: `float`, `uint8`, `string[]`).
  final String datatype;

  /// Tipo Dart correspondente (ex: `double`, `int`, `List<String>`).
  final String dartType;
  final String? unit;
  final num? min;
  final num? max;
  final List<Object>? allowed;
  final Object? defaultValue;

  bool get isNumeric => dartType == 'int' || dartType == 'double';
}

final class VssSpec {
  VssSpec._(this.roots, this.leaves);

  final List<VssBranch> roots;

  /// Todas as folhas indexadas pelo caminho completo.
  final Map<String, VssLeaf> leaves;

  static const leafTypes = {'sensor', 'actuator', 'attribute'};

  static const _scalarTypes = {
    'boolean': 'bool',
    'string': 'String',
    'float': 'double',
    'double': 'double',
    'int8': 'int',
    'int16': 'int',
    'int32': 'int',
    'int64': 'int',
    'uint8': 'int',
    'uint16': 'int',
    'uint32': 'int',
    'uint64': 'int',
  };

  static VssSpec parse(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?> || decoded.isEmpty) {
      throw const FormatException('VSS spec inválido: a raiz deve ser um objeto com ao menos um branch.');
    }
    final leaves = <String, VssLeaf>{};
    final roots = [
      for (final MapEntry(:key, :value) in decoded.entries)
        switch (_parseNode(key, key, value, leaves)) {
          final VssBranch branch => branch,
          VssLeaf() => throw FormatException('VSS spec inválido em "$key": a raiz deve ser um branch.'),
        },
    ];
    return VssSpec._(roots, leaves);
  }

  static VssNode _parseNode(String name, String path, Object? raw, Map<String, VssLeaf> leaves) {
    if (raw is! Map<String, Object?>) _fail(path, 'o nó deve ser um objeto.');
    final type = raw['type'];
    final description = raw['description'] as String?;

    if (type == 'branch') {
      final children = raw['children'];
      if (children is! Map<String, Object?> || children.isEmpty) {
        _fail(path, 'branch sem "children".');
      }
      return VssBranch(name, path, description, [
        for (final MapEntry(:key, :value) in children.entries) _parseNode(key, '$path.$key', value, leaves),
      ]);
    }

    if (!leafTypes.contains(type)) {
      _fail(path, '"type" deve ser branch, ${leafTypes.join(', ')} (recebido: $type).');
    }
    final leaf = _parseLeaf(name, path, description, type as String, raw);
    leaves[path] = leaf;
    return leaf;
  }

  static VssLeaf _parseLeaf(String name, String path, String? description, String type, Map<String, Object?> raw) {
    final datatype = raw['datatype'];
    if (datatype is! String) _fail(path, 'folha sem "datatype".');

    final isArray = datatype.endsWith('[]');
    final scalar = _scalarTypes[isArray ? datatype.substring(0, datatype.length - 2) : datatype];
    if (scalar == null) _fail(path, 'datatype desconhecido "$datatype".');
    final dartType = isArray ? 'List<$scalar>' : scalar;

    final min = raw['min'];
    final max = raw['max'];
    final allowed = raw['allowed'];
    final defaultValue = raw['default'];
    final isNumeric = !isArray && (scalar == 'int' || scalar == 'double');

    if ((min != null || max != null) && !isNumeric) _fail(path, '"min"/"max" só valem para datatypes numéricos.');
    if (min != null && min is! num) _fail(path, '"min" deve ser numérico.');
    if (max != null && max is! num) _fail(path, '"max" deve ser numérico.');
    if (min is num && max is num && min > max) _fail(path, '"min" maior que "max".');
    if (allowed != null && (allowed is! List || allowed.isEmpty)) _fail(path, '"allowed" deve ser uma lista não vazia.');
    if (defaultValue != null && !_matchesType(defaultValue, scalar, isArray)) {
      _fail(path, '"default" ($defaultValue) não é compatível com $datatype.');
    }

    return VssLeaf(
      name,
      path,
      description,
      type: type,
      datatype: datatype,
      dartType: dartType,
      unit: raw['unit'] as String?,
      min: min as num?,
      max: max as num?,
      allowed: (allowed as List?)?.cast<Object>(),
      defaultValue: defaultValue,
    );
  }

  static bool _matchesType(Object value, String scalar, bool isArray) {
    if (isArray) return value is List && value.every((e) => _matchesType(e as Object, scalar, false));
    return switch (scalar) {
      'bool' => value is bool,
      'String' => value is String,
      'int' => value is int,
      _ => value is num,
    };
  }

  static Never _fail(String path, String message) => throw FormatException('VSS spec inválido em "$path": $message');
}

/// Converte um valor JSON em um literal Dart válido em contexto `const`.
String dartLiteral(Object? value, {String? dartType}) => switch (value) {
  null => 'null',
  final String s => "'${s.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$')}'",
  final num n when dartType == 'double' => n.toDouble().toString(),
  final num n => n.toString(),
  final bool b => b.toString(),
  final List<Object?> list => '[${list.map(dartLiteral).join(', ')}]',
  _ => throw ArgumentError('Valor sem literal Dart: $value'),
};
