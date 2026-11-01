import 'package:meta/meta.dart';

/// COVESA VSS classification of a leaf.
enum VssNodeType { sensor, actuator, attribute }

/// Typed, `const` reference to a VSS signal.
///
/// Equality is by path, so it is safe as a map key and as a family provider parameter.
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

/// Signal metadata from the VSS spec (optionally adjusted by a vehicle profile).
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

  /// Whether [value] respects `min`, `max` and `allowed`.
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

/// Per-model metadata adjustment (the equivalent of a vss-tools overlay).
@immutable
final class VssMetaOverride {
  const VssMetaOverride({this.min, this.max, this.allowed});

  final num? min;
  final num? max;
  final List<Object>? allowed;
}
