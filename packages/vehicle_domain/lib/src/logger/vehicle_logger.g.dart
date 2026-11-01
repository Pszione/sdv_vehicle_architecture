// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_logger.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Audit log em memória (ring buffer) de comandos, rejeições e mudanças
/// confirmadas de atuadores.
///
/// Telemetria de sensores (velocidade, ADAS a 30 Hz...) não é registrada,
/// porque inundaria o buffer.

@ProviderFor(VehicleLogger)
final vehicleLoggerProvider = VehicleLoggerProvider._();

/// Audit log em memória (ring buffer) de comandos, rejeições e mudanças
/// confirmadas de atuadores.
///
/// Telemetria de sensores (velocidade, ADAS a 30 Hz...) não é registrada,
/// porque inundaria o buffer.
final class VehicleLoggerProvider
    extends $NotifierProvider<VehicleLogger, LoggerState> {
  /// Audit log em memória (ring buffer) de comandos, rejeições e mudanças
  /// confirmadas de atuadores.
  ///
  /// Telemetria de sensores (velocidade, ADAS a 30 Hz...) não é registrada,
  /// porque inundaria o buffer.
  VehicleLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleLoggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleLoggerHash();

  @$internal
  @override
  VehicleLogger create() => VehicleLogger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoggerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoggerState>(value),
    );
  }
}

String _$vehicleLoggerHash() => r'c429640899d6b839876a0c0a6e91a9f1f8386419';

/// Audit log em memória (ring buffer) de comandos, rejeições e mudanças
/// confirmadas de atuadores.
///
/// Telemetria de sensores (velocidade, ADAS a 30 Hz...) não é registrada,
/// porque inundaria o buffer.

abstract class _$VehicleLogger extends $Notifier<LoggerState> {
  LoggerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LoggerState, LoggerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoggerState, LoggerState>,
              LoggerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
