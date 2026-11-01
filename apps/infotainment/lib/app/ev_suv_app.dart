import 'package:flutter/material.dart';

import 'home_shell.dart';

class EvSuvApp extends StatelessWidget {
  const EvSuvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV SUV Infotainment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.teal, brightness: .dark),
      ),
      home: const HomeShell(),
    );
  }
}
