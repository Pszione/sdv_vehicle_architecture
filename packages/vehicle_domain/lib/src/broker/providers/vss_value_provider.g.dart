// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vss_value_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Value of a single signal. Only notifies when *this* signal changes, so a
/// cluster widget is not rebuilt by telemetry of other signals.
///
/// Prefer the typed `ref.watchSignal(Vss.Vehicle.Speed)` from vehicle_ui_kit.

@ProviderFor(vssValue)
final vssValueProvider = VssValueFamily._();

/// Value of a single signal. Only notifies when *this* signal changes, so a
/// cluster widget is not rebuilt by telemetry of other signals.
///
/// Prefer the typed `ref.watchSignal(Vss.Vehicle.Speed)` from vehicle_ui_kit.

final class VssValueProvider
    extends $FunctionalProvider<Object?, Object?, Object?>
    with $Provider<Object?> {
  /// Value of a single signal. Only notifies when *this* signal changes, so a
  /// cluster widget is not rebuilt by telemetry of other signals.
  ///
  /// Prefer the typed `ref.watchSignal(Vss.Vehicle.Speed)` from vehicle_ui_kit.
  VssValueProvider._({
    required VssValueFamily super.from,
    required VssSignal<Object> super.argument,
  }) : super(
         retry: null,
         name: r'vssValueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vssValueHash();

  @override
  String toString() {
    return r'vssValueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Object? create(Ref ref) {
    final argument = this.argument as VssSignal<Object>;
    return vssValue(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Object?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VssValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vssValueHash() => r'e5910392b6bc574761d6c1d78d62c73b32cbc18e';

/// Value of a single signal. Only notifies when *this* signal changes, so a
/// cluster widget is not rebuilt by telemetry of other signals.
///
/// Prefer the typed `ref.watchSignal(Vss.Vehicle.Speed)` from vehicle_ui_kit.

final class VssValueFamily extends $Family
    with $FunctionalFamilyOverride<Object?, VssSignal<Object>> {
  VssValueFamily._()
    : super(
        retry: null,
        name: r'vssValueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Value of a single signal. Only notifies when *this* signal changes, so a
  /// cluster widget is not rebuilt by telemetry of other signals.
  ///
  /// Prefer the typed `ref.watchSignal(Vss.Vehicle.Speed)` from vehicle_ui_kit.

  VssValueProvider call(VssSignal<Object> signal) =>
      VssValueProvider._(argument: signal, from: this);

  @override
  String toString() => r'vssValueProvider';
}
