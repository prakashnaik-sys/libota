import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/book.dart';

class GoogleBooksApi {
  static Future<List<Book>> search(String q) async {
    final r = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$q'));

    final data = jsonDecode(r.body);

    if (data['items'] == null) return [];

    return (data['items'] as List).map<Book>((e) {
      final v = e['volumeInfo'];
      return Book(
        id: e['id'],
        title: v['title'] ?? '',
        author: v['authors']?.first ?? 'Unknown',
        coverUrl: v['imageLinks']?['thumbnail'] ?? '',
      );
    }).toList();
  }
}
