import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

/// Typed access to signals and to the dispatcher from widgets.
extension VehicleWidgetRef on WidgetRef {
  /// Watches a single signal. The widget only rebuilds when *this* value changes.
  T? watchSignal<T extends Object>(VssSignal<T> signal) => watch(vssValueProvider(signal)) as T?;

  /// Sends the command through the `CommandDispatcher` and shows the reason when it is rejected.
  CommandResult dispatchCommand(BuildContext context, VehicleCommand<Object> command) {
    final result = read(commandDispatcherProvider.notifier).dispatch(command);
    if (!result.isSuccess) {
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade900,
            content: Row(
              children: [
                const Icon(Icons.block, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(result.message ?? 'Command rejected.')),
              ],
            ),
          ),
        );
    }
    return result;
  }
}
