// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telltale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bulb check: every telltale lights up for [duration] when the vehicle becomes READY,
/// so the driver can see that none is burnt out (regulatory requirement for red telltales).

@ProviderFor(BulbCheck)
final bulbCheckProvider = BulbCheckProvider._();

/// Bulb check: every telltale lights up for [duration] when the vehicle becomes READY,
/// so the driver can see that none is burnt out (regulatory requirement for red telltales).
final class BulbCheckProvider extends $NotifierProvider<BulbCheck, bool> {
  /// Bulb check: every telltale lights up for [duration] when the vehicle becomes READY,
  /// so the driver can see that none is burnt out (regulatory requirement for red telltales).
  BulbCheckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bulbCheckProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bulbCheckHash();

  @$internal
  @override
  BulbCheck create() => BulbCheck();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$bulbCheckHash() => r'c21d6c254a285717c45ab0040ada706c28195730';

/// Bulb check: every telltale lights up for [duration] when the vehicle becomes READY,
/// so the driver can see that none is burnt out (regulatory requirement for red telltales).

abstract class _$BulbCheck extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// State of one telltale. Watches only that telltale's inputs (value and E2E status), so
/// at 60 FPS a speed change never re-evaluates the parking brake light.

@ProviderFor(telltaleState)
final telltaleStateProvider = TelltaleStateFamily._();

/// State of one telltale. Watches only that telltale's inputs (value and E2E status), so
/// at 60 FPS a speed change never re-evaluates the parking brake light.

final class TelltaleStateProvider extends $FunctionalProvider<TelltaleState, TelltaleState, TelltaleState>
    with $Provider<TelltaleState> {
  /// State of one telltale. Watches only that telltale's inputs (value and E2E status), so
  /// at 60 FPS a speed change never re-evaluates the parking brake light.
  TelltaleStateProvider._({required TelltaleStateFamily super.from, required Telltale super.argument})
    : super(
        retry: null,
        name: r'telltaleStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telltaleStateHash();

  @override
  String toString() {
    return r'telltaleStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TelltaleState> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  TelltaleState create(Ref ref) {
    final argument = this.argument as Telltale;
    return telltaleState(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelltaleState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<TelltaleState>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is TelltaleStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$telltaleStateHash() => r'2731f190de4b9314b8b7718e1ff4a32b55f3725e';

/// State of one telltale. Watches only that telltale's inputs (value and E2E status), so
/// at 60 FPS a speed change never re-evaluates the parking brake light.

final class TelltaleStateFamily extends $Family with $FunctionalFamilyOverride<TelltaleState, Telltale> {
  TelltaleStateFamily._()
    : super(
        retry: null,
        name: r'telltaleStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State of one telltale. Watches only that telltale's inputs (value and E2E status), so
  /// at 60 FPS a speed change never re-evaluates the parking brake light.

  TelltaleStateProvider call(Telltale telltale) => TelltaleStateProvider._(argument: telltale, from: this);

  @override
  String toString() => r'telltaleStateProvider';
}
