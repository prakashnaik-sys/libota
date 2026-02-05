import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: controller.mode,
            onChanged: (v) => controller.setMode(v!),
          ),

          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: controller.mode,
            onChanged: (v) => controller.setMode(v!),
          ),

          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: controller.mode,
            onChanged: (v) => controller.setMode(v!),
          ),
        ],
      ),
    );
  }
}
