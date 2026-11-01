import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Mostra [child] só se o perfil ativo tem o [signal]. Caso contrário, mostra
/// [fallback] (ex: uma versão desabilitada) ou nada.
class VehicleFeatureGuard extends ConsumerWidget {
  const VehicleFeatureGuard({super.key, required this.signal, required this.child, this.fallback});

  final VssSignal<Object> signal;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSupported = ref.watch(isSignalSupportedProvider(signal));
    return isSupported ? child : fallback ?? const SizedBox.shrink();
  }
}
