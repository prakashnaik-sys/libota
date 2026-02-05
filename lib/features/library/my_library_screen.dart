import '../reader/epub_reader.dart';
import 'package:flutter/material.dart';
import '../../core/utils/library_storage.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  late Future<List<Map<String, dynamic>>> _library;

  @override
  void initState() {
    super.initState();
    _library = LibraryStorage.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _library,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!;
          if (books.isEmpty) {
            return const Center(
              child: Text('No offline books yet'),
            );
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (_, i) {
              final book = books[i];
              return ListTile(
                leading: Image.network(book['coverUrl'], width: 50),
                title: Text(book['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EpubReaderScreen(
                        filePath: book['filePath'],
                        bookKey: book['key'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
