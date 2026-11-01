/// Perfis de fábrica gerados a partir de `*.profile.json`.
///
/// Para criar um modelo, adicione um `<id>.profile.json` nesta pasta, declare o
/// `part` abaixo e rode o build_runner. Sinais inexistentes no spec quebram o build.
library;

import 'package:vehicle_domain/vehicle_domain.dart';

part 'entry.profile.g.dart';
part 'flagship.profile.g.dart';
part 'luxury_ev_suv.profile.g.dart';
part 'premium.profile.g.dart';

/// Perfis disponíveis para seleção na HMI, do mais simples ao mais completo.
const factoryProfiles = [entryProfile, premiumProfile, luxuryEvSuvProfile, flagshipProfile];
