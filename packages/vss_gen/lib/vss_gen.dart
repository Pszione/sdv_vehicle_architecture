/// Builders do build_runner que transformam o spec COVESA VSS (formato JSON do
/// vss-tools) em código Dart tipado.
///
/// - `vss_tree`: `*.vss.json` -> árvore `Vss.Vehicle...` + `vssCatalog`.
/// - `vss_profile`: `*.profile.json` -> `const VehicleProfile`, validado contra o spec.
library;

import 'package:build/build.dart';

import 'src/vss_profile_builder.dart';
import 'src/vss_tree_builder.dart';

Builder vssTreeBuilder(BuilderOptions options) =>
    VssTreeBuilder(partOf: options.config['part_of'] as String? ?? 'vss.dart');

Builder vssProfileBuilder(BuilderOptions options) => VssProfileBuilder(
  specUri: options.config['spec'] as String,
  partOf: options.config['part_of'] as String? ?? 'factory_profiles.dart',
);
