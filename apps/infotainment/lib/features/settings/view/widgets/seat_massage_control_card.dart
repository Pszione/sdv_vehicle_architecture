import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../../../../core/command_source.dart';

/// Driver seat massage (COVESA `Massage.TypeActive` + `Massage.Level`, where level 0 = off).
/// The driver seat is always `Row1.DriverSide`, on LHD and RHD cars alike.
class SeatMassageControlCard extends ConsumerWidget {
  const SeatMassageControlCard({super.key});

  static const _off = 'OFF';
  static const _defaultLevel = 50;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final massage = Vss.Vehicle.Cabin.Seat.Row1.DriverSide.Massage;
    final types = ref.watch(activeVehicleProfileProvider.select((p) => p.metaOf(massage.TypeActive)?.allowed));
    final level = ref.watchSignal(massage.Level) ?? 0;
    final type = ref.watchSignal(massage.TypeActive);
    final selected = level == 0 ? _off : type;

    void select(String option) {
      if (option == _off) {
        ref.dispatchCommand(
          context,
          VehicleCommand(signal: massage.Level, value: 0, source: infotainmentCommandSource),
        );
        return;
      }
      ref.dispatchCommand(
        context,
        VehicleCommand(signal: massage.TypeActive, value: option, source: infotainmentCommandSource),
      );
      if (level == 0) {
        ref.dispatchCommand(
          context,
          VehicleCommand(signal: massage.Level, value: _defaultLevel, source: infotainmentCommandSource),
        );
      }
    }

    return VehicleFeatureGuard(
      signal: massage.Level,
      child: VehicleControlCard(
        icon: Icons.airline_seat_recline_extra,
        title: 'Driver seat massage',
        status: selected,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<String>(
            segments: [
              for (final option in [_off, ...?types?.cast<String>()]) ButtonSegment(value: option, label: Text(option)),
            ],
            selected: {?selected},
            emptySelectionAllowed: true,
            onSelectionChanged: (selection) => select(selection.first),
          ),
        ),
      ),
    );
  }
}
