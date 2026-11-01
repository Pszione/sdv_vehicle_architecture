// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_rules_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Todas as regras do veículo.
///
/// Uma regra só roda se o seu `target` existe no perfil ativo, então a lista
/// pode ser universal: um carro sem diferencial bloqueável nunca chega à
/// [DiffLockSafetyRule]. Sobrescreva no app só para mudar limiares por modelo.

@ProviderFor(activeSafetyRules)
final activeSafetyRulesProvider = ActiveSafetyRulesProvider._();

/// Todas as regras do veículo.
///
/// Uma regra só roda se o seu `target` existe no perfil ativo, então a lista
/// pode ser universal: um carro sem diferencial bloqueável nunca chega à
/// [DiffLockSafetyRule]. Sobrescreva no app só para mudar limiares por modelo.

final class ActiveSafetyRulesProvider
    extends
        $FunctionalProvider<
          List<SafetyRule>,
          List<SafetyRule>,
          List<SafetyRule>
        >
    with $Provider<List<SafetyRule>> {
  /// Todas as regras do veículo.
  ///
  /// Uma regra só roda se o seu `target` existe no perfil ativo, então a lista
  /// pode ser universal: um carro sem diferencial bloqueável nunca chega à
  /// [DiffLockSafetyRule]. Sobrescreva no app só para mudar limiares por modelo.
  ActiveSafetyRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSafetyRulesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSafetyRulesHash();

  @$internal
  @override
  $ProviderElement<List<SafetyRule>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SafetyRule> create(Ref ref) {
    return activeSafetyRules(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SafetyRule> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SafetyRule>>(value),
    );
  }
}

String _$activeSafetyRulesHash() => r'6d97b0c4b3771a2b5b39fd2e145b529812b6fe8b';
