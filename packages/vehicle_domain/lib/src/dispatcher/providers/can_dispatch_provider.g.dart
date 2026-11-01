// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'can_dispatch_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reavalia se [command] seria aprovado agora, para habilitar ou desabilitar controles.
///
/// Só observa o perfil e os `inputs` das regras que se aplicam ao comando,
/// então telemetria de outros sinais não dispara reavaliação.

@ProviderFor(canDispatch)
final canDispatchProvider = CanDispatchFamily._();

/// Reavalia se [command] seria aprovado agora, para habilitar ou desabilitar controles.
///
/// Só observa o perfil e os `inputs` das regras que se aplicam ao comando,
/// então telemetria de outros sinais não dispara reavaliação.

final class CanDispatchProvider
    extends $FunctionalProvider<CommandResult, CommandResult, CommandResult>
    with $Provider<CommandResult> {
  /// Reavalia se [command] seria aprovado agora, para habilitar ou desabilitar controles.
  ///
  /// Só observa o perfil e os `inputs` das regras que se aplicam ao comando,
  /// então telemetria de outros sinais não dispara reavaliação.
  CanDispatchProvider._({
    required CanDispatchFamily super.from,
    required VehicleCommand<Object> super.argument,
  }) : super(
         retry: null,
         name: r'canDispatchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$canDispatchHash();

  @override
  String toString() {
    return r'canDispatchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CommandResult> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CommandResult create(Ref ref) {
    final argument = this.argument as VehicleCommand<Object>;
    return canDispatch(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommandResult value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommandResult>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CanDispatchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$canDispatchHash() => r'cd27b076367602156c8c04ea595edb22d2478372';

/// Reavalia se [command] seria aprovado agora, para habilitar ou desabilitar controles.
///
/// Só observa o perfil e os `inputs` das regras que se aplicam ao comando,
/// então telemetria de outros sinais não dispara reavaliação.

final class CanDispatchFamily extends $Family
    with $FunctionalFamilyOverride<CommandResult, VehicleCommand<Object>> {
  CanDispatchFamily._()
    : super(
        retry: null,
        name: r'canDispatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Reavalia se [command] seria aprovado agora, para habilitar ou desabilitar controles.
  ///
  /// Só observa o perfil e os `inputs` das regras que se aplicam ao comando,
  /// então telemetria de outros sinais não dispara reavaliação.

  CanDispatchProvider call(VehicleCommand<Object> command) =>
      CanDispatchProvider._(argument: command, from: this);

  @override
  String toString() => r'canDispatchProvider';
}
