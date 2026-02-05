import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:libota/models/book.dart';

class OpenLibraryApi {
  static Future<List<Book>> searchBooks({
    required String query,
    required int page,
  }) async {
    final res = await http.get(Uri.parse(
        'https://openlibrary.org/search.json?q=$query&page=$page'));

    final data = jsonDecode(res.body);
    final List docs = data['docs'];

    return docs.map<Book>((e) {
      final ia = e['ia'] != null ? e['ia'][0] : null;

      return Book(
        id: e['key'],
        title: e['title'] ?? '',
        author: e['author_name']?.first ?? 'Unknown',
        coverUrl: e['cover_i'] != null
            ? 'https://covers.openlibrary.org/b/id/${e['cover_i']}-L.jpg'
            : '',
        internetArchiveUrl:
        ia != null ? 'https://archive.org/stream/$ia?ui=embed' : null,
      );
    }).toList();
  }
}
