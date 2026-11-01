import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../vss/vss_signal.dart';
import '../vss_broker.dart';

part 'vss_value_provider.g.dart';

/// Valor de um único sinal. Só notifica quando *este* sinal muda, então um
/// widget do cluster não é reconstruído por telemetria de outros sinais.
///
/// Prefira o acesso tipado `ref.watchSignal(Vss.Vehicle.Speed)` do vehicle_ui_kit.
@riverpod
Object? vssValue(Ref ref, VssSignal<Object> signal) =>
    ref.watch(vssBrokerProvider.select((values) => values[signal.path]));
