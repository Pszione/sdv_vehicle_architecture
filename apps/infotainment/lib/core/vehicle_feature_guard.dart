import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleFeatureGuard extends ConsumerWidget {
  final String vssPath;
  final Widget child;
  final Widget? fallback; // Opcional: o que mostrar se o recurso não existir

  const VehicleFeatureGuard({
    super.key,
    required this.vssPath,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuta se o sinal é suportado no catálogo/perfil do veículo
    final isSupported = ref.watch(isSignalSupportedProvider(vssPath));

    if (!isSupported) {
      return fallback ?? const SizedBox.shrink(); // Some com o widget da tela
    }

    return child;
  }
}