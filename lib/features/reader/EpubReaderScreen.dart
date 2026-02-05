import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import '../../core/utils/reading_progress.dart';

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

  double progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = EpubController(
      document: EpubDocument.openFile(File(widget.filePath)),
    );
  }

  void _saveProgress(EpubChapterViewValue? value) async {
    if (value?.chapterNumber != null) {
      final total = _controller.document.chapters.length ?? 1;
      await ReadingProgress.saveChapter(
        widget.bookKey,
        value!.chapterNumber!,
        total,
      );

      final percent =
      await ReadingProgress.loadPercent(widget.bookKey);

      setState(() => progress = percent);
    }
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

            SwitchListTile(
              title: const Text("Night Mode"),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress / 100),
        ),
      ),
      body: EpubView(
        controller: _controller,
        style: EpubViewStyle(
          backgroundColor:
          darkMode ? Colors.black : Colors.white,
          foregroundColor:
          darkMode ? Colors.white : Colors.black,
          fontSize: fontSize,
        ),
        onChapterChanged: _saveProgress,
      ),
    );
  }
}
