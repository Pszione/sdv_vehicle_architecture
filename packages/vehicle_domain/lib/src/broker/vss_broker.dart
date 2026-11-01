@riverpod
class VssBroker extends _$VssBroker {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  /// Atualiza o valor de um sinal se ele existir no catálogo do veículo
  void setSignal(String vssPath, dynamic value) {
    final catalogAsync = ref.read(vssCatalogProvider);

    catalogAsync.whenData((catalog) {
      if (!catalog.containsKey(vssPath)) {
        // O sinal não é suportado por esta versão do carro
        return;
      }

      final metaData = catalog[vssPath]!;

      // Validação de limites (para tipos numéricos)
      dynamic validatedValue = value;
      if (metaData.min != null && value is num) {
        if (value < metaData.min!) return;
      }
      if (metaData.max != null && value is num) {
        if (value > metaData.max!) return;
      }

      state = {
        ...state,
        vssPath: validatedValue,
      };
    });
  }
}