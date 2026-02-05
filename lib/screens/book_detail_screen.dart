import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'reader_screen.dart';
import '../models/book.dart';
import '../reader/reader_screen.dart';


class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(book.coverUrl, height: 220),
            const SizedBox(height: 16),
            Text(book.title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            /// 1️⃣ Internet Archive
            ElevatedButton(
              onPressed: book.internetArchiveUrl == null
                  ? null
                  : () => launchUrl(
                Uri.parse(book.internetArchiveUrl!),
                mode: LaunchMode.externalApplication,
              ),
              child: const Text('Borrow to read (Internet Archive)'),
            ),

            /// 2️⃣ EPUB from Gutenberg / Standard Ebooks
            ElevatedButton(
              onPressed: book.epubUrl == null
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReaderScreen(
                      source: book.epubUrl!,
                    ),
                  ),
                );
              },
              child: const Text('Read free EPUB'),
            ),

            /// 3️⃣ Import local EPUB
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['epub', 'pdf'],
                );

                if (book.internetArchiveUrl != null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReaderScreen(url: book.internetArchiveUrl!),
                        ),
                      );
                    },
                    child: const Text('Read (Internet Archive)'),
                  ),

                if (result != null && result.files.single.path != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReaderScreen(
                        source: result.files.single.path!,
                        isLocal: true,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Import your own EPUB'),
            ),

            /// 4️⃣ External search
            ElevatedButton(
              onPressed: () {
                final query =
                Uri.encodeComponent('${book.title} ${book.author}');
                launchUrl(
                  Uri.parse('https://www.google.com/search?q=$query'),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('Find external copy'),
            ),
          ],
        ),
      ),
    );
  }
}
