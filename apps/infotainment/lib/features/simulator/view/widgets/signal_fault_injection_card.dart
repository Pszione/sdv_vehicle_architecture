import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';
import 'package:vehicle_simulators/vehicle_simulators.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

/// Corrupts the link of an E2E-protected sensor and shows how the gateway classifies it.
class SignalFaultInjectionCard extends ConsumerStatefulWidget {
  const SignalFaultInjectionCard({super.key});

  @override
  ConsumerState<SignalFaultInjectionCard> createState() => _SignalFaultInjectionCardState();
}

class _SignalFaultInjectionCardState extends ConsumerState<SignalFaultInjectionCard> {
  VssSignal<Object> _signal = Vss.Vehicle.Speed;

  static String labelOf(VssSignal<Object> signal) => signal.path.split('.').skip(1).join('.');

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(activeVehicleProfileProvider);
    final signals = [
      for (final signal in E2eProtectedSignals.dataIds.keys)
        if (profile.metaOf(signal) != null) signal,
    ];
    if (signals.isEmpty) return const SizedBox.shrink();
    final simulator = ref.read(telemetrySimulatorProvider.notifier);
    final fault = simulator.e2eFaultOf(_signal);

    return VehicleControlCard(
      icon: Icons.verified_user_outlined,
      title: 'E2E signal faults',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButton<VssSignal<Object>>(
            isExpanded: true,
            value: signals.contains(_signal) ? _signal : signals.first,
            items: [
              for (final signal in signals)
                DropdownMenuItem(
                  value: signal,
                  child: _SignalStatusRow(signal: signal, label: labelOf(signal)),
                ),
            ],
            onChanged: (signal) => setState(() => _signal = signal!),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final option in E2eFault.values)
                ChoiceChip(
                  label: Text(option.label),
                  selected: option == fault,
                  onSelected: (_) => setState(() => simulator.injectE2eFault(_signal, option)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalStatusRow extends ConsumerWidget {
  const _SignalStatusRow({required this.signal, required this.label});

  final VssSignal<Object> signal;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watchSignalStatus(signal);
    final color = switch (status) {
      SignalStatus.valid => Colors.greenAccent,
      SignalStatus.notAvailable => Colors.white38,
      SignalStatus.stale => Colors.amberAccent,
      SignalStatus.invalid => Colors.redAccent,
    };

    return Row(
      children: [
        Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        Text(
          status.label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
