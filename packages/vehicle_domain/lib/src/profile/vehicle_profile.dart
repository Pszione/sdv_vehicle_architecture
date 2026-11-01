import 'package:meta/meta.dart';

import '../vss/vss.dart';
import '../vss/vss_signal.dart';

enum DriverSide { left, right }

/// Configuração de um modelo/trim: quais sinais do spec mestre existem neste
/// carro e quais metadados mudam (ex: faixa da suspensão).
///
/// Instâncias são geradas pelo `vss_profile` a partir de `*.profile.json`,
/// já validadas contra o spec durante o build.
@immutable
final class VehicleProfile {
  const VehicleProfile({
    required this.id,
    required this.trimName,
    required this.driverSide,
    required this.supportedPaths,
    this.overrides = const {},
  });

  final String id;
  final String trimName;
  final DriverSide driverSide;
  final Set<String> supportedPaths;
  final Map<String, VssMetaOverride> overrides;

  bool supports(VssSignal<Object> signal) => supportedPaths.contains(signal.path);

  /// Metadados efetivos do sinal neste modelo, ou `null` se ele não existe aqui.
  VssSignalMeta? metaOf(VssSignal<Object> signal) {
    if (!supports(signal)) return null;
    final meta = vssCatalog[signal.path]!;
    final override = overrides[signal.path];
    return override == null ? meta : meta.apply(override);
  }
}
