@riverpod
class VssSignal extends _$VssSignal {
  @override
  Object? build(String vssPath) {
    final catalogAsync = ref.watch(vssCatalogProvider);

    return catalogAsync.when(
      data: (catalog) {
        if (!catalog.containsKey(vssPath)) {
          // Retorna null quando o recurso não é suportado pelo carro
          return null;
        }

        // Retorna o valor atual do broker ou o padrão definido no JSON VSS
        final brokerState = ref.watch(vssBrokerProvider);
        return brokerState[vssPath] ?? catalog[vssPath]!.defaultValue;
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Permite atualizar o valor do sinal diretamente pela UI/Comando
  void update(Object? newValue) {
    ref.read(vssBrokerProvider.notifier).setSignal(vssPath, newValue);
  }
}