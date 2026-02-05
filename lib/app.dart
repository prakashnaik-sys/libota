import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'features/home/home_screen.dart';

class LibOTAApp extends StatelessWidget {
  const LibOTAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'LibOTA',
      debugShowCheckedModeBanner: false,

      themeMode: themeProvider.themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}
