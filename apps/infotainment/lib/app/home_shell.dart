import 'package:flutter/material.dart';
import 'package:vehicle_profiles/vehicle_profiles.dart';
import 'package:vehicle_ui_kit/vehicle_ui_kit.dart';

import '../features/climate/view/climate_screen.dart';
import '../features/settings/view/vehicle_settings_screen.dart';
import '../features/simulator/view/simulator_screen.dart';

/// Top-level navigation: "Vehicle" (production controls), "Climate" and "Simulator".
/// Uses a side rail on wide screens (tablet landscape) and a bottom bar otherwise.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _railMinWidth = 600.0;
  static const _destinations = [
    (icon: Icons.directions_car_outlined, selectedIcon: Icons.directions_car, label: 'Vehicle'),
    (icon: Icons.thermostat_outlined, selectedIcon: Icons.thermostat, label: 'Climate'),
    (icon: Icons.science_outlined, selectedIcon: Icons.science, label: 'Simulator'),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // IndexedStack keeps both tabs alive, so slider positions survive tab switches.
    final body = IndexedStack(
      index: _index,
      children: const [VehicleSettingsScreen(), ClimateScreen(), SimulatorScreen()],
    );
    final isWide = MediaQuery.sizeOf(context).width >= _railMinWidth;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CarProfileSelectorBar(profiles: factoryProfiles),
            Expanded(
              child: isWide
                  ? Row(
                      children: [
                        NavigationRail(
                          selectedIndex: _index,
                          labelType: NavigationRailLabelType.all,
                          onDestinationSelected: (index) => setState(() => _index = index),
                          destinations: [
                            for (final d in _destinations)
                              NavigationRailDestination(
                                icon: Icon(d.icon),
                                selectedIcon: Icon(d.selectedIcon),
                                label: Text(d.label),
                              ),
                          ],
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(child: body),
                      ],
                    )
                  : body,
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (index) => setState(() => _index = index),
              destinations: [
                for (final d in _destinations)
                  NavigationDestination(icon: Icon(d.icon), selectedIcon: Icon(d.selectedIcon), label: d.label),
              ],
            ),
    );
  }
}
