import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBook {
  final String title;
  final String author;
  final String coverUrl;

  GoogleBook({
    required this.title,
    required this.author,
    required this.coverUrl,
  });
}

class GoogleBooksApi {
  static Future<List<GoogleBook>> search(String query) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}';

    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);

    final List items = data['items'] ?? [];

    return items.map((item) {
      final info = item['volumeInfo'];
      return GoogleBook(
        title: info['title'] ?? 'Unknown',
        author:
        (info['authors'] != null) ? info['authors'][0] : 'Unknown',
        coverUrl:
        info['imageLinks']?['thumbnail'] ?? '',
      );
    }).toList();
  }
}
