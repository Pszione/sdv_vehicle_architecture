// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current [PowerMode]. Only re-evaluates when one of its input signals changes.

@ProviderFor(powerMode)
final powerModeProvider = PowerModeProvider._();

/// Current [PowerMode]. Only re-evaluates when one of its input signals changes.

final class PowerModeProvider extends $FunctionalProvider<PowerMode?, PowerMode?, PowerMode?>
    with $Provider<PowerMode?> {
  /// Current [PowerMode]. Only re-evaluates when one of its input signals changes.
  PowerModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'powerModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$powerModeHash();

  @$internal
  @override
  $ProviderElement<PowerMode?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  PowerMode? create(Ref ref) {
    return powerMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PowerMode? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PowerMode?>(value));
  }
}

String _$powerModeHash() => r'a234e81f429854c3dd3b35de2bd21cfbdfe39656';
