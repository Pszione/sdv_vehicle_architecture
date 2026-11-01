import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_dispatcher_provider.g.dart';

@riverpod
class CommandDispatcher extends _$CommandDispatcher {
  @override
  void build() {
    // O build() não precisa armazenar estado fixo de regras.
    // Opcionalmente pode ser usado para inicializar dependências de suporte.
  }

  /// Ponto de entrada único para despacho e validação de intenções no veículo
  CommandResult dispatch(VehicleCommand command) {
    // 1. Validação de Capacidade (Verifica se o VSS Path existe no modelo ativo)
    final isSupported = ref.read(isSignalSupportedProvider(command.targetVssPath));
    if (!isSupported) {
      print('[Dispatcher] RECUSADO: "${command.targetVssPath}" não equipado neste veículo.');
      return CommandResult.notSupported(command.targetVssPath);
    }

    // 2. Leitura Dinâmica do Pipeline de Segurança
    // Lê as regras injetadas no ProviderScope (incluindo overrides por modelo de carro)
    final activeRules = ref.read(activeSafetyRulesProvider);

    for (final rule in activeRules) {
      final validationResult = rule.validate(command, ref);

      if (validationResult != null && !validationResult.isSuccess) {
        print(
          '[Dispatcher] REJEITADO POR SEGURANÇA [${rule.runtimeType}]: ${validationResult.message}',
        );

        // Registra a violação de segurança no audit log do veículo
        ref
            .read(vehicleLoggerProvider.notifier)
            .logSafetyRejection(
              vssPath: command.targetVssPath,
              attemptedPayload: command.payload,
              reason: validationResult.message ?? 'Regra de segurança violada',
              source: command.source,
            );

        return validationResult;
      }
    }

    // 3. Resolução da Zona e Dispositivo Zonal
    final zonalCommand = ZonalCommand(
      targetZone: _resolveTargetZone(command.targetVssPath),
      deviceId: _resolveDeviceId(command.targetVssPath),
      vssPath: command.targetVssPath,
      actionPayload: command.payload,
    );

    // 4. Emitir no Barramento Zonal
    ref.read(zonalCommandBusProvider.notifier).emit(zonalCommand);

    print('[Dispatcher] APROVADO: Disparado para ${zonalCommand.targetZone}');
    return CommandResult.executed();
  }

  String _resolveTargetZone(String vssPath) {
    if (vssPath.contains('Door.Row1.Left')) return 'ZONE_WEST';
    if (vssPath.contains('Door.Row1.Right')) return 'ZONE_EAST';
    if (vssPath.contains('Sunroof')) return 'ZONE_TOP';
    if (vssPath.contains('Suspension')) return 'ZONE_SOUTH';
    return 'ZONE_CENTRAL';
  }

  String _resolveDeviceId(String vssPath) {
    if (vssPath.contains('Door.Row1.Left')) return 'DOOR_FRONT_LEFT';
    if (vssPath.contains('Door.Row1.Right')) return 'DOOR_FRONT_RIGHT';
    if (vssPath.contains('Sunroof')) return 'SUNROOF_ACTUATOR';
    if (vssPath.contains('Suspension')) return 'AIR_SUSPENSION_MODULE';
    return 'GENERIC_ACTUATOR';
  }

  /// Avalia um comando hipotético sem dispará-lo no barramento (Dry Run)
  CommandResult evaluate(VehicleCommand command) {
    // 1. Checa capacidade VSS
    final isSupported = ref.read(isSignalSupportedProvider(command.targetVssPath));
    if (!isSupported) {
      return CommandResult.notSupported(command.targetVssPath);
    }

    // 2. Executa as regras de segurança ativas
    final activeRules = ref.read(activeSafetyRulesProvider);
    for (final rule in activeRules) {
      final result = rule.validate(command, ref);
      if (result != null && !result.isSuccess) {
        return result; // Retorna a primeira falha/motivo
      }
    }

    return CommandResult.executed(); // Pode ser executado com sucesso
  }
}
