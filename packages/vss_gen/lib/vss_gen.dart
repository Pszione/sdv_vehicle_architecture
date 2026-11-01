/// build_runner builders that turn a COVESA VSS spec (vss-tools JSON export shape)
/// into typed Dart code.
///
/// - `vss_tree`: `*.vss.json` -> `Vss.Vehicle...` tree + `vssCatalog`.
/// - `vss_profile`: `*.profile.json` -> `const VehicleProfile`, validated against the spec.
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
