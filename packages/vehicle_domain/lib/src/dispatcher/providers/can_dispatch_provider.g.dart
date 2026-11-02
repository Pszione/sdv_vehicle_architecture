// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'can_dispatch_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Re-evaluates whether [command] would be approved right now, to warn the
/// user before they tap a control.
///
/// Only watches the profile, the power mode and the `inputs` (value and status) of the
/// rules that apply to the command, so telemetry of unrelated signals does not trigger a re-evaluation.

@ProviderFor(canDispatch)
final canDispatchProvider = CanDispatchFamily._();

/// Re-evaluates whether [command] would be approved right now, to warn the
/// user before they tap a control.
///
/// Only watches the profile, the power mode and the `inputs` (value and status) of the
/// rules that apply to the command, so telemetry of unrelated signals does not trigger a re-evaluation.

final class CanDispatchProvider extends $FunctionalProvider<CommandResult, CommandResult, CommandResult>
    with $Provider<CommandResult> {
  /// Re-evaluates whether [command] would be approved right now, to warn the
  /// user before they tap a control.
  ///
  /// Only watches the profile, the power mode and the `inputs` (value and status) of the
  /// rules that apply to the command, so telemetry of unrelated signals does not trigger a re-evaluation.
  CanDispatchProvider._({required CanDispatchFamily super.from, required VehicleCommand<Object> super.argument})
    : super(
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
  $ProviderElement<CommandResult> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CommandResult create(Ref ref) {
    final argument = this.argument as VehicleCommand<Object>;
    return canDispatch(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommandResult value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CommandResult>(value));
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

String _$canDispatchHash() => r'269c4ffdb74d4854d20da100138cc8d7ec985093';

/// Re-evaluates whether [command] would be approved right now, to warn the
/// user before they tap a control.
///
/// Only watches the profile, the power mode and the `inputs` (value and status) of the
/// rules that apply to the command, so telemetry of unrelated signals does not trigger a re-evaluation.

final class CanDispatchFamily extends $Family with $FunctionalFamilyOverride<CommandResult, VehicleCommand<Object>> {
  CanDispatchFamily._()
    : super(
        retry: null,
        name: r'canDispatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Re-evaluates whether [command] would be approved right now, to warn the
  /// user before they tap a control.
  ///
  /// Only watches the profile, the power mode and the `inputs` (value and status) of the
  /// rules that apply to the command, so telemetry of unrelated signals does not trigger a re-evaluation.

  CanDispatchProvider call(VehicleCommand<Object> command) => CanDispatchProvider._(argument: command, from: this);

  @override
  String toString() => r'canDispatchProvider';
}
