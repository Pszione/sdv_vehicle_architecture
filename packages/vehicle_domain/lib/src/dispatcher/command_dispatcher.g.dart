// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_dispatcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where approved commands go. The app wires it to the zonal bus.

@ProviderFor(commandSink)
final commandSinkProvider = CommandSinkProvider._();

/// Where approved commands go. The app wires it to the zonal bus.

final class CommandSinkProvider extends $FunctionalProvider<CommandSink, CommandSink, CommandSink>
    with $Provider<CommandSink> {
  /// Where approved commands go. The app wires it to the zonal bus.
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
  $ProviderElement<CommandSink> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CommandSink create(Ref ref) {
    return commandSink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommandSink value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CommandSink>(value));
  }
}

String _$commandSinkHash() => r'127397e785831d3abe31b62ca178fea14913cc37';

/// Single entry point for vehicle commands.

@ProviderFor(CommandDispatcher)
final commandDispatcherProvider = CommandDispatcherProvider._();

/// Single entry point for vehicle commands.
final class CommandDispatcherProvider extends $NotifierProvider<CommandDispatcher, void> {
  /// Single entry point for vehicle commands.
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
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$commandDispatcherHash() => r'212b0bc83e6a6c330748ae8c8c03d124a0162b01';

/// Single entry point for vehicle commands.

abstract class _$CommandDispatcher extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
