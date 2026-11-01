import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../vss/vss_signal.dart';
import '../vehicle_profile.dart';

part 'active_vehicle_profile.g.dart';

/// Profile the vehicle boots with. Every app overrides it in its `ProviderScope`.
@Riverpod(keepAlive: true)
VehicleProfile initialVehicleProfile(Ref ref) =>
    throw UnimplementedError('Override initialVehicleProfileProvider in the app ProviderScope.');

/// Active profile. Switching it resets the [VssBroker] to the new model's signals.
@Riverpod(keepAlive: true)
class ActiveVehicleProfile extends _$ActiveVehicleProfile {
  @override
  VehicleProfile build() => ref.watch(initialVehicleProfileProvider);

  void setProfile(VehicleProfile profile) => state = profile;
}

/// Whether the signal exists in the active profile. Only notifies when the answer changes.
@riverpod
bool isSignalSupported(Ref ref, VssSignal<Object> signal) =>
    ref.watch(activeVehicleProfileProvider.select((profile) => profile.supports(signal)));
