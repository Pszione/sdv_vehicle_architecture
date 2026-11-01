class VssPath {
  final List<String> segments;

  VssPath(String rawPath) : segments = rawPath.split('.');

  /// Retorna o nó pai (ex: "Vehicle.Cabin.Door.Row1.Left")
  VssPath get parent => VssPath(segments.sublist(0, segments.length - 1).join('.'));

  /// Retorna o nó folha / nome do sinal (ex: "IsLocked")
  String get leaf => segments.last;

  /// Gera um caminho irmão seguro sob o mesmo nó pai
  VssPath sibling(String newLeaf) {
    final parentSegments = segments.sublist(0, segments.length - 1);
    return VssPath([...parentSegments, newLeaf].join('.'));
  }

  @override
  String toString() => segments.join('.');
}