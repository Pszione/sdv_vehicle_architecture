// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zonal_command_sink.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [ZonalCommandSink] bound to the active profile. Apps use it to override `commandSinkProvider`.

@ProviderFor(zonalCommandSink)
final zonalCommandSinkProvider = ZonalCommandSinkProvider._();

/// [ZonalCommandSink] bound to the active profile. Apps use it to override `commandSinkProvider`.

final class ZonalCommandSinkProvider extends $FunctionalProvider<ZonalCommandSink, ZonalCommandSink, ZonalCommandSink>
    with $Provider<ZonalCommandSink> {
  /// [ZonalCommandSink] bound to the active profile. Apps use it to override `commandSinkProvider`.
  ZonalCommandSinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zonalCommandSinkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zonalCommandSinkHash();

  @$internal
  @override
  $ProviderElement<ZonalCommandSink> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ZonalCommandSink create(Ref ref) {
    return zonalCommandSink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZonalCommandSink value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ZonalCommandSink>(value));
  }
}

String _$zonalCommandSinkHash() => r'b3278d04a403ab801f0d6a4b283adf12f8276de2';
