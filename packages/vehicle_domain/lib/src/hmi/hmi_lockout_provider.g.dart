// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hmi_lockout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reason why [feature] is locked right now, or `null` if it is available.
/// Only rebuilds when the "moving" state flips, not on every speed sample.

@ProviderFor(hmiLockoutReason)
final hmiLockoutReasonProvider = HmiLockoutReasonFamily._();

/// Reason why [feature] is locked right now, or `null` if it is available.
/// Only rebuilds when the "moving" state flips, not on every speed sample.

final class HmiLockoutReasonProvider extends $FunctionalProvider<String?, String?, String?> with $Provider<String?> {
  /// Reason why [feature] is locked right now, or `null` if it is available.
  /// Only rebuilds when the "moving" state flips, not on every speed sample.
  HmiLockoutReasonProvider._({required HmiLockoutReasonFamily super.from, required HmiFeature super.argument})
    : super(
        retry: null,
        name: r'hmiLockoutReasonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hmiLockoutReasonHash();

  @override
  String toString() {
    return r'hmiLockoutReasonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as HmiFeature;
    return hmiLockoutReason(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is HmiLockoutReasonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hmiLockoutReasonHash() => r'2bd8dcd1a17fd36b8fabf679ca3376464c689833';

/// Reason why [feature] is locked right now, or `null` if it is available.
/// Only rebuilds when the "moving" state flips, not on every speed sample.

final class HmiLockoutReasonFamily extends $Family with $FunctionalFamilyOverride<String?, HmiFeature> {
  HmiLockoutReasonFamily._()
    : super(
        retry: null,
        name: r'hmiLockoutReasonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Reason why [feature] is locked right now, or `null` if it is available.
  /// Only rebuilds when the "moving" state flips, not on every speed sample.

  HmiLockoutReasonProvider call(HmiFeature feature) => HmiLockoutReasonProvider._(argument: feature, from: this);

  @override
  String toString() => r'hmiLockoutReasonProvider';
}
