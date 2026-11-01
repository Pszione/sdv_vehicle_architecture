import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_domain/vehicle_domain.dart';

import 'safety_precheck_banner.dart';
import 'vehicle_feature_guard.dart';
import 'vehicle_widget_ref.dart';

/// Switch bound to a boolean actuator: shows the confirmed state, sends commands
/// through the dispatcher and warns ahead when switching to [precheckValue] would be rejected.
/// Hidden when the active profile lacks the signal.
class VehicleCommandSwitch extends ConsumerWidget {
  const VehicleCommandSwitch({
    super.key,
    required this.signal,
    required this.title,
    required this.source,
    this.subtitle,
    this.precheckValue = true,
  });

  final VssSignal<bool> signal;
  final String title;
  final String? subtitle;

  /// Source recorded in the audit log (e.g. "INFOTAINMENT_UI").
  final String source;

  /// The state whose rejection is announced ahead (usually switching on).
  final bool precheckValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watchSignal(signal) ?? false;

    return VehicleFeatureGuard(
      signal: signal,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title),
            subtitle: subtitle == null ? null : Text(subtitle!),
            value: value,
            onChanged: (newValue) =>
                ref.dispatchCommand(context, VehicleCommand(signal: signal, value: newValue, source: source)),
          ),
          if (value != precheckValue)
            SafetyPrecheckBanner(
              command: VehicleCommand(signal: signal, value: precheckValue, source: source),
            ),
        ],
      ),
    );
  }
}
