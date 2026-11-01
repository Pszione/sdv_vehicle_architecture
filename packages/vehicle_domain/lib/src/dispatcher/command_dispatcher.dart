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

/// Where approved commands go. The app wires it to the zonal bus.
@Riverpod(keepAlive: true)
CommandSink commandSink(Ref ref) =>
    throw UnimplementedError('Override commandSinkProvider in the app ProviderScope (e.g. ZonalCommandSink).');

/// Single entry point for vehicle commands.
@Riverpod(keepAlive: true)
class CommandDispatcher extends _$CommandDispatcher {
  @override
  void build() {}

  /// Validates the command and, if approved, sends it to the [CommandSink].
  CommandResult dispatch(VehicleCommand<Object> command) {
    final result = evaluate(command);
    final logger = ref.read(vehicleLoggerProvider.notifier);

    if (!result.isSuccess) {
      if (result.status == CommandStatus.rejectedBySafetyRule) logger.logSafetyRejection(command, result);
      return result;
    }

    // Log before sending: the bus may confirm the telemetry synchronously.
    logger.logCommand(command);
    ref.read(commandSinkProvider).send(command);
    return result;
  }

  /// Dry run: evaluates the command against the current state without sending it.
  CommandResult evaluate(VehicleCommand<Object> command) => CommandValidator(
    profile: ref.read(activeVehicleProfileProvider),
    signals: SnapshotSignalReader(ref.read(vssBrokerProvider)),
    rules: ref.read(activeSafetyRulesProvider),
  ).validate(command);
}
