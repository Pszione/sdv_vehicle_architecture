// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_dispatcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Para onde vão os comandos aprovados. O app liga ao barramento zonal.

@ProviderFor(commandSink)
final commandSinkProvider = CommandSinkProvider._();

/// Para onde vão os comandos aprovados. O app liga ao barramento zonal.

final class CommandSinkProvider
    extends $FunctionalProvider<CommandSink, CommandSink, CommandSink>
    with $Provider<CommandSink> {
  /// Para onde vão os comandos aprovados. O app liga ao barramento zonal.
  CommandSinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandSinkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandSinkHash();

  @$internal
  @override
  $ProviderElement<CommandSink> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CommandSink create(Ref ref) {
    return commandSink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommandSink value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommandSink>(value),
    );
  }
}

String _$commandSinkHash() => r'ae3f2a43cc6febfd3f1f63eb9d556b79e66dabda';

/// Ponto de entrada único para comandos ao veículo.

@ProviderFor(CommandDispatcher)
final commandDispatcherProvider = CommandDispatcherProvider._();

/// Ponto de entrada único para comandos ao veículo.
final class CommandDispatcherProvider
    extends $NotifierProvider<CommandDispatcher, void> {
  /// Ponto de entrada único para comandos ao veículo.
  CommandDispatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandDispatcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandDispatcherHash();

  @$internal
  @override
  CommandDispatcher create() => CommandDispatcher();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$commandDispatcherHash() => r'2c91847defd3ba3db96331fc692b4631edb879b7';

/// Ponto de entrada único para comandos ao veículo.

abstract class _$CommandDispatcher extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
