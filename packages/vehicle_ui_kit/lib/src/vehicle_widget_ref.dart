import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Acesso tipado aos sinais e ao dispatcher a partir de widgets.
extension VehicleWidgetRef on WidgetRef {
  /// Observa um único sinal. O widget só é reconstruído quando *este* valor muda.
  T? watchSignal<T extends Object>(VssSignal<T> signal) => watch(vssValueProvider(signal)) as T?;

  /// Envia o comando pelo `CommandDispatcher` e mostra o motivo se ele for recusado.
  CommandResult dispatchCommand(BuildContext context, VehicleCommand<Object> command) {
    final result = read(commandDispatcherProvider.notifier).dispatch(command);
    if (!result.isSuccess) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(result.message ?? 'Comando recusado.')));
    }
    return result;
  }
}
