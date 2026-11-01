import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../vss/vss_signal.dart';
import '../vss_broker.dart';

part 'vss_value_provider.g.dart';

/// Value of a single signal. Only notifies when *this* signal changes, so a
/// cluster widget is not rebuilt by telemetry of other signals.
///
/// Prefer the typed `ref.watchSignal(Vss.Vehicle.Speed)` from vehicle_ui_kit.
@riverpod
Object? vssValue(Ref ref, VssSignal<Object> signal) =>
    ref.watch(vssBrokerProvider.select((values) => values[signal.path]));
