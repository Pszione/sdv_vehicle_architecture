import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import '../../../../core/cluster_colors.dart';

/// Turn signals at both ends, and only the telltales that are on in between.
class TelltaleBar extends StatelessWidget {
  const TelltaleBar({super.key});

  static final _middle = [
    for (final telltale in Telltale.values)
      if (telltale != Telltale.leftTurn && telltale != Telltale.rightTurn) telltale,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          const TelltaleIcon(Telltale.leftTurn, keepsSpace: true),
          Expanded(
            child: Center(child: Wrap(spacing: 18, children: [for (final telltale in _middle) TelltaleIcon(telltale)])),
          ),
          const TelltaleIcon(Telltale.rightTurn, keepsSpace: true),
        ],
      ),
    );
  }
}

/// One telltale. Rebuilds only when *its* state changes; flashing is a local animation.
class TelltaleIcon extends ConsumerWidget {
  const TelltaleIcon(this.telltale, {super.key, this.keepsSpace = false});

  final Telltale telltale;

  /// Turn signals keep their place even when off, so they never jump.
  final bool keepsSpace;

  static const _size = 32.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(telltaleStateProvider(telltale));
    if (state == TelltaleState.off) {
      return keepsSpace ? const SizedBox.square(dimension: _size) : const SizedBox.shrink();
    }

    final symbol = Semantics(
      label: 'Telltale ${telltale.name}',
      child: _TelltaleSymbol(telltale: telltale, color: ClusterColors.telltale(telltale.color)),
    );
    return state == TelltaleState.flashing ? _Flashing(child: symbol) : symbol;
  }
}

class _TelltaleSymbol extends StatelessWidget {
  const _TelltaleSymbol({required this.telltale, required this.color});

  final Telltale telltale;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const size = TelltaleIcon._size;
    final icon = switch (telltale) {
      Telltale.leftTurn => Icons.arrow_back_rounded,
      Telltale.rightTurn => Icons.arrow_forward_rounded,
      Telltale.highBeam => Icons.highlight,
      Telltale.cruiseActive => Icons.speed,
      Telltale.seatbelt => Icons.airline_seat_recline_normal,
      Telltale.doorOpen => Icons.sensor_door_outlined,
      Telltale.lowVoltageBattery => Icons.battery_alert,
      Telltale.laneDeparture => Icons.edit_road,
      Telltale.tirePressure => Icons.tire_repair,
      Telltale.lowTractionBattery => Icons.battery_1_bar,
      Telltale.signalFault => Icons.warning_amber_rounded,
      Telltale.parkingBrake || Telltale.escActive || Telltale.escOff => null,
    };
    if (icon != null) return Icon(icon, size: size, color: color);

    // Text symbols for the ones Material has no icon for.
    final label = switch (telltale) {
      Telltale.parkingBrake => 'P',
      Telltale.escOff => 'ESC\nOFF',
      _ => 'ESC',
    };
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: telltale == Telltale.parkingBrake ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(color: color, width: 2),
        borderRadius: telltale == Telltale.parkingBrake ? null : BorderRadius.circular(6),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: label.length > 3 ? 8 : 12, fontWeight: FontWeight.w800, height: 1),
      ),
    );
  }
}

/// ~1.5 Hz blink (turn signals: 60–120 flashes per minute).
class _Flashing extends StatefulWidget {
  const _Flashing({required this.child});

  final Widget child;

  @override
  State<_Flashing> createState() => _FlashingState();
}

class _FlashingState extends State<_Flashing> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 667))..repeat();
  late final _opacity = _controller.drive(
    TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 1),
      TweenSequenceItem(tween: ConstantTween(0.1), weight: 1),
    ]),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _opacity, child: widget.child);
}
