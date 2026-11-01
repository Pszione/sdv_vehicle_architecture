import 'package:meta/meta.dart';

/// Classificação COVESA VSS de uma folha.
enum VssNodeType { sensor, actuator, attribute }

/// Referência tipada e `const` a um sinal VSS.
///
/// A igualdade é pelo caminho, então pode ser usada com segurança como chave
/// de mapas e como parâmetro de providers family.
@immutable
final class VssSignal<T extends Object> {
  const VssSignal(this.path);

  final String path;

  @override
  bool operator ==(Object other) => other is VssSignal && other.path == path;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => path;
}

/// Metadados de um sinal, vindos do spec VSS (e opcionalmente ajustados pelo perfil).
@immutable
final class VssSignalMeta {
  const VssSignalMeta({
    required this.type,
    required this.datatype,
    this.unit,
    this.min,
    this.max,
    this.allowed,
    this.defaultValue,
  });

  final VssNodeType type;
  final String datatype;
  final String? unit;
  final num? min;
  final num? max;
  final List<Object>? allowed;
  final Object? defaultValue;

  bool get isActuator => type == VssNodeType.actuator;

  /// `true` se [value] respeita `min`, `max` e `allowed`.
  bool accepts(Object? value) {
    if (value == null) return false;
    if (value is num) {
      if (min case final min? when value < min) return false;
      if (max case final max? when value > max) return false;
    }
    return allowed?.contains(value) ?? true;
  }

  VssSignalMeta apply(VssMetaOverride override) => VssSignalMeta(
    type: type,
    datatype: datatype,
    unit: unit,
    min: override.min ?? min,
    max: override.max ?? max,
    allowed: override.allowed ?? allowed,
    defaultValue: defaultValue,
  );
}

/// Ajuste de metadados por modelo (equivalente a um overlay do vss-tools).
@immutable
final class VssMetaOverride {
  const VssMetaOverride({this.min, this.max, this.allowed});

  final num? min;
  final num? max;
  final List<Object>? allowed;
}
