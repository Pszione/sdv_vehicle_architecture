// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signal_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Status of every supervised signal, by VSS path. Empty until the `E2eReceiver` starts
/// supervising, so code that never receives protected frames (unit tests) sees every signal
/// as valid. Reset on a profile switch.

@ProviderFor(SignalStatusRegistry)
final signalStatusRegistryProvider = SignalStatusRegistryProvider._();

/// Status of every supervised signal, by VSS path. Empty until the `E2eReceiver` starts
/// supervising, so code that never receives protected frames (unit tests) sees every signal
/// as valid. Reset on a profile switch.
final class SignalStatusRegistryProvider extends $NotifierProvider<SignalStatusRegistry, Map<String, SignalStatus>> {
  /// Status of every supervised signal, by VSS path. Empty until the `E2eReceiver` starts
  /// supervising, so code that never receives protected frames (unit tests) sees every signal
  /// as valid. Reset on a profile switch.
  SignalStatusRegistryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signalStatusRegistryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signalStatusRegistryHash();

  @$internal
  @override
  SignalStatusRegistry create() => SignalStatusRegistry();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, SignalStatus> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Map<String, SignalStatus>>(value));
  }
}

String _$signalStatusRegistryHash() => r'63e75ab57e5a8641ad67e5d9a18f689aa12e91d2';

/// Status of every supervised signal, by VSS path. Empty until the `E2eReceiver` starts
/// supervising, so code that never receives protected frames (unit tests) sees every signal
/// as valid. Reset on a profile switch.

abstract class _$SignalStatusRegistry extends $Notifier<Map<String, SignalStatus>> {
  Map<String, SignalStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, SignalStatus>, Map<String, SignalStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, SignalStatus>, Map<String, SignalStatus>>,
              Map<String, SignalStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Status of a single signal. Only notifies when *this* status changes.

@ProviderFor(signalStatus)
final signalStatusProvider = SignalStatusFamily._();

/// Status of a single signal. Only notifies when *this* status changes.

final class SignalStatusProvider extends $FunctionalProvider<SignalStatus, SignalStatus, SignalStatus>
    with $Provider<SignalStatus> {
  /// Status of a single signal. Only notifies when *this* status changes.
  SignalStatusProvider._({required SignalStatusFamily super.from, required VssSignal<Object> super.argument})
    : super(
        retry: null,
        name: r'signalStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signalStatusHash();

  @override
  String toString() {
    return r'signalStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SignalStatus> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SignalStatus create(Ref ref) {
    final argument = this.argument as VssSignal<Object>;
    return signalStatus(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignalStatus value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SignalStatus>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is SignalStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signalStatusHash() => r'c92c555c011f0cec56345208b4e3bc77c79e2207';

/// Status of a single signal. Only notifies when *this* status changes.

final class SignalStatusFamily extends $Family with $FunctionalFamilyOverride<SignalStatus, VssSignal<Object>> {
  SignalStatusFamily._()
    : super(
        retry: null,
        name: r'signalStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Status of a single signal. Only notifies when *this* status changes.

  SignalStatusProvider call(VssSignal<Object> signal) => SignalStatusProvider._(argument: signal, from: this);

  @override
  String toString() => r'signalStatusProvider';
}
