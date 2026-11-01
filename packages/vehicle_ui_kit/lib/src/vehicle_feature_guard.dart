import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Shows [child] only if the active profile has [signal]. Otherwise shows
/// [fallback] (e.g. a disabled version) or nothing.
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
