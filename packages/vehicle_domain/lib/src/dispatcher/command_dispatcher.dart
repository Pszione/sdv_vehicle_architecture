import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../broker/signal_reader.dart';
import '../broker/vss_broker.dart';
import '../logger/vehicle_logger.dart';
import '../profile/providers/active_vehicle_profile.dart';
import '../safety_rules/providers/safety_rules_provider.dart';
import 'command_validator.dart';
import 'domain/command_sink.dart';
import 'domain/vehicle_commands.dart';

part 'command_dispatcher.g.dart';

/// Para onde vão os comandos aprovados. O app liga ao barramento zonal.
@Riverpod(keepAlive: true)
CommandSink commandSink(Ref ref) =>
    throw UnimplementedError('Sobrescreva commandSinkProvider no ProviderScope do app (ex: ZonalCommandSink).');

/// Ponto de entrada único para comandos ao veículo.
@Riverpod(keepAlive: true)
class CommandDispatcher extends _$CommandDispatcher {
  @override
  void build() {}

  /// Valida e, se aprovado, envia o comando ao [CommandSink].
  CommandResult dispatch(VehicleCommand<Object> command) {
    final result = evaluate(command);
    final logger = ref.read(vehicleLoggerProvider.notifier);

    if (!result.isSuccess) {
      if (result.status == CommandStatus.rejectedBySafetyRule) logger.logSafetyRejection(command, result);
      return result;
    }

    ref.read(commandSinkProvider).send(command);
    logger.logCommand(command);
    return result;
  }

  /// Dry run: avalia o comando contra o estado atual sem enviá-lo.
  CommandResult evaluate(VehicleCommand<Object> command) => CommandValidator(
    profile: ref.read(activeVehicleProfileProvider),
    signals: SnapshotSignalReader(ref.read(vssBrokerProvider)),
    rules: ref.read(activeSafetyRulesProvider),
  ).validate(command);
}
