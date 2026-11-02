// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e2e_receiver.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Receiving end of the E2E-protected signals, conceptually running in the central gateway:
/// checks every frame (CRC, alive counter), runs the E2E state machine, supervises deadlines,
/// and only then publishes the value to the `VssBroker`.
///
/// It lives in the domain so any producer (the simulators today, a vehicle bus bridge later)
/// can feed it. Supervision starts with the first frame.

@ProviderFor(E2eReceiver)
final e2eReceiverProvider = E2eReceiverProvider._();

/// Receiving end of the E2E-protected signals, conceptually running in the central gateway:
/// checks every frame (CRC, alive counter), runs the E2E state machine, supervises deadlines,
/// and only then publishes the value to the `VssBroker`.
///
/// It lives in the domain so any producer (the simulators today, a vehicle bus bridge later)
/// can feed it. Supervision starts with the first frame.
final class E2eReceiverProvider extends $NotifierProvider<E2eReceiver, void> {
  /// Receiving end of the E2E-protected signals, conceptually running in the central gateway:
  /// checks every frame (CRC, alive counter), runs the E2E state machine, supervises deadlines,
  /// and only then publishes the value to the `VssBroker`.
  ///
  /// It lives in the domain so any producer (the simulators today, a vehicle bus bridge later)
  /// can feed it. Supervision starts with the first frame.
  E2eReceiverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'e2eReceiverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$e2eReceiverHash();

  @$internal
  @override
  E2eReceiver create() => E2eReceiver();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$e2eReceiverHash() => r'86fc9ed410bf1398db87cc133a72a70f8f9a3b57';

/// Receiving end of the E2E-protected signals, conceptually running in the central gateway:
/// checks every frame (CRC, alive counter), runs the E2E state machine, supervises deadlines,
/// and only then publishes the value to the `VssBroker`.
///
/// It lives in the domain so any producer (the simulators today, a vehicle bus bridge later)
/// can feed it. Supervision starts with the first frame.

abstract class _$E2eReceiver extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
