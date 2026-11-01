import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Massagem do banco do motorista. O lado do banco vem do perfil (LHD/RHD)
/// e os modos vêm do `allowed` do spec VSS.
class SeatMassageControlCard extends ConsumerWidget {
  const SeatMassageControlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverSide = ref.watch(activeVehicleProfileProvider.select((profile) => profile.driverSide));
    final mode = switch (driverSide) {
      DriverSide.left => Vss.Vehicle.Seat.Row1.Left.Massage.Mode,
      DriverSide.right => Vss.Vehicle.Seat.Row1.Right.Massage.Mode,
    };

    return VehicleFeatureGuard(
      signal: mode,
      child: _MassageModeSelector(mode: mode),
    );
  }
}

class _MassageModeSelector extends ConsumerWidget {
  const _MassageModeSelector({required this.mode});

  final VssSignal<String> mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.watch(activeVehicleProfileProvider.select((profile) => profile.metaOf(mode)?.allowed));
    final current = ref.watchSignal(mode);
    final modes = allowed?.cast<String>() ?? const <String>[];
    if (modes.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const ListTile(leading: Icon(Icons.airline_seat_recline_extra), title: Text('Massagem do motorista')),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<String>(
                segments: [for (final m in modes) ButtonSegment(value: m, label: Text(m))],
                selected: {current ?? modes.first},
                onSelectionChanged: (selection) => ref.dispatchCommand(
                  context,
                  VehicleCommand(signal: mode, value: selection.first, source: infotainmentCommandSource),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
