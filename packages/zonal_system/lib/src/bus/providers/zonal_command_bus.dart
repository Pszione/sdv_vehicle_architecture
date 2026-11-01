import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/zonal_command.dart';

part 'zonal_command_bus_provider.g.dart';

@riverpod
class ZonalCommandBus extends _$ZonalCommandBus {
  final _controller = StreamController<ZonalCommand>.broadcast();

  @override
  Stream<ZonalCommand> build() {
    ref.onDispose(() => _controller.close());
    return _controller.stream;
  }

  /// Dispara o comando filtrado e validado no barramento zonal
  void emit(ZonalCommand command) {
    _controller.add(command);
  }
}