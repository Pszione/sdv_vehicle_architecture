/// Factory profiles generated from `*.profile.json`.
///
/// To add a model, create `<id>.profile.json` in this folder, declare its
/// `part` below and run build_runner. Signals missing from the spec fail the build.
library;

import 'package:vehicle_domain/vehicle_domain.dart';

part 'entry.profile.g.dart';
part 'flagship.profile.g.dart';
part 'luxury_ev_suv.profile.g.dart';
part 'premium.profile.g.dart';

/// Profiles available for selection in the HMI, from the simplest to the most complete.
const factoryProfiles = [entryProfile, premiumProfile, luxuryEvSuvProfile, flagshipProfile];
