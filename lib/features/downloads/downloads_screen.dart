import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: const Center(
        child: Text(
          'No downloaded books yet',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
