import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/home/home_screen.dart';
import 'features/search/search_screen.dart';
import 'features/downloads/downloads_screen.dart';
import 'features/settings/settings_screen.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const LibOTA(),
    ),
  );
}

class LibOTA extends StatelessWidget {
  const LibOTA({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LibOTA',

      /// 👇 THIS IS WHAT MAKES THEMES WORK
      themeMode: themeController.mode,

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final screens = const [
    HomeScreen(),
    SearchScreen(),
    DownloadsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.red,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
