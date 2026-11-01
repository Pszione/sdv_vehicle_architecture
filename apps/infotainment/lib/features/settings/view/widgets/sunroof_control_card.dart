import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Teto solar: o comando sai ao soltar o slider. Depois disso, o slider segue
/// a posição real reportada pelo atuador.
class SunroofControlCard extends ConsumerStatefulWidget {
  const SunroofControlCard({super.key});

  @override
  ConsumerState<SunroofControlCard> createState() => _SunroofControlCardState();
}

class _SunroofControlCardState extends ConsumerState<SunroofControlCard> {
  /// Valor enquanto o usuário arrasta; `null` mostra a telemetria.
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final sunroof = Vss.Vehicle.Cabin.Sunroof;
    final position = ref.watchSignal(sunroof.Position) ?? 0.0;
    final isFaulted = ref.watchSignal(sunroof.IsFaulted) ?? false;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(isFaulted ? Icons.warning_amber : Icons.wb_sunny_outlined),
            title: const Text('Teto solar'),
            subtitle: Text(isFaulted ? 'Falha no atuador' : '${(position * 100).round()}% aberto'),
          ),
          Slider(
            value: _dragValue ?? position,
            onChanged: (value) => setState(() => _dragValue = value),
            onChangeEnd: (value) {
              setState(() => _dragValue = null);
              ref.dispatchCommand(
                context,
                VehicleCommand(signal: sunroof.Position, value: value, source: infotainmentCommandSource),
              );
            },
          ),
        ],
      ),
    );
  }
}
