import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';

class EpubReaderScreen extends StatefulWidget {
  final String filePath;
  final String bookKey;

  const EpubReaderScreen({
    super.key,
    required this.filePath,
    required this.bookKey,
  });

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  late final EpubController _controller;

  double fontSize = 16;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    _controller = EpubController(
      document: EpubDocument.openFile(
        File(widget.filePath),
      ),
    );
  }

  void _showControls() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Reading Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Font size control
            Row(
              children: [
                const Icon(Icons.text_fields),
                Expanded(
                  child: Slider(
                    min: 12,
                    max: 28,
                    value: fontSize,
                    onChanged: (v) {
                      setState(() => fontSize = v);
                    },
                  ),
                ),
              ],
            ),

            // Night mode
            SwitchListTile(
              title: const Text('Night Mode'),
              value: darkMode,
              onChanged: (v) {
                setState(() => darkMode = v);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showControls,
          ),
        ],
      ),
      body: EpubView(
        controller: _controller,
        builders: EpubViewBuilders<DefaultBuilderOptions>(
          options: DefaultBuilderOptions(
            textStyle: TextStyle(
              fontSize: fontSize,
              color: darkMode ? Colors.white : Colors.black,
              fontFamily: 'serif',
            ),
          ),
          chapterDividerBuilder: (_) => const Divider(),
        ),
      ),
      backgroundColor: darkMode ? Colors.black : Colors.white,
    );
  }
}
