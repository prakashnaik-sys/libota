import 'dart:convert';
import 'package:http/http.dart' as http;

class GutenbergBook {
  final String title;
  final String epubUrl;

  GutenbergBook({required this.title, required this.epubUrl});
}

class GutendexApi {
  static Future<List<GutenbergBook>> search(String query) async {
    final url =
        'https://gutendex.com/books?search=${Uri.encodeComponent(query)}';

    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);

    final List results = data['results'] ?? [];

    return results.map((b) {
      return GutenbergBook(
        title: b['title'],
        epubUrl: b['formats']['application/epub+zip'],
      );
    }).toList();
  }
}
