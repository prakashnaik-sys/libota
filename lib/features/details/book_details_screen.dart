import 'package:flutter/material.dart';
import 'package:libota/models/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  void open(String url) {
    launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Column(
        children: [
          Image.network(book.coverUrl, height: 220),
          const SizedBox(height: 12),

          if (book.internetArchiveUrl != null)
            ElevatedButton(
              onPressed: () => open(book.internetArchiveUrl!),
              child: const Text('Borrow (Internet Archive)'),
            ),

          if (book.epubUrl != null)
            ElevatedButton(
              onPressed: () => open(book.epubUrl!),
              child: const Text('Read EPUB'),
            ),

          if (book.pdfUrl != null)
            ElevatedButton(
              onPressed: () => open(book.pdfUrl!),
              child: const Text('Read PDF'),
            ),
        ],
      ),
    );
  }
}
