import 'package:flutter/material.dart';

import '../core/cluster_colors.dart';
import '../features/cluster/view/cluster_screen.dart';

class ClusterApp extends StatelessWidget {
  const ClusterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV SUV Cluster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ClusterColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: ClusterColors.accent, brightness: Brightness.dark),
      ),
      home: const ClusterScreen(),
    );
  }
}
