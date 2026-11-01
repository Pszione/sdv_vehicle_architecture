import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'can_dispatch_provider.g.dart';

/// Provider que reavalia dinamicamente se um comando é permitido no estado atual do carro
@riverpod
CommandResult canDispatch(Ref ref, VehicleCommand command) {
  // Para tornar a avaliação reativa, assistimos aos sinais relevantes
  ref.watch(vssBrokerProvider);

  // Executa o dry-run no dispatcher
  return ref.watch(commandDispatcherProvider.notifier).evaluate(command);
}