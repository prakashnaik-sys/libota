import 'package:flutter/material.dart';
import '../../core/api/google_books_api.dart';
import '../../core/api/gutendex_api.dart';

class UnifiedSearchResult {
  final String title;
  final String author;
  final String coverUrl;
  final String? epubUrl;

  UnifiedSearchResult({
    required this.title,
    required this.author,
    required this.coverUrl,
    this.epubUrl,
  });
}

class UnifiedSearchScreen extends StatefulWidget {
  const UnifiedSearchScreen({super.key});

  @override
  State<UnifiedSearchScreen> createState() => _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends State<UnifiedSearchScreen> {
  final controller = TextEditingController();
  bool loading = false;
  List<UnifiedSearchResult> results = [];

  Future<void> search(String query) async {
    setState(() => loading = true);

    final google = await GoogleBooksApi.search(query);
    final gutendex = await GutendexApi.search(query);

    final merged = google.map((g) {
      final match = gutendex.firstWhere(
            (e) => e.title.toLowerCase().contains(g.title.toLowerCase()),
        orElse: () => GutenbergBook(title: '', epubUrl: ''),
      );

      return UnifiedSearchResult(
        title: g.title,
        author: g.author,
        coverUrl: g.coverUrl,
        epubUrl: match.epubUrl.isNotEmpty ? match.epubUrl : null,
      );
    }).toList();

    setState(() {
      results = merged;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              onSubmitted: search,
              decoration: const InputDecoration(
                hintText: 'Search books',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (loading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) {
                final b = results[i];
                return ListTile(
                  leading: b.coverUrl.isNotEmpty
                      ? Image.network(b.coverUrl)
                      : const Icon(Icons.book),
                  title: Text(b.title),
                  subtitle: Text(b.author),
                  trailing: b.epubUrl != null
                      ? const Icon(Icons.download)
                      : const Icon(Icons.public),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
