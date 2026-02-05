import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/book.dart';

class GutendexApi {
  static Future<List<Book>> fetch(int page) async {
    final r = await http.get(Uri.parse('https://gutendex.com/books/?page=$page'));
    final data = jsonDecode(r.body);

    return (data['results'] as List).map<Book>((e) {
      return Book(
        id: e['id'].toString(),
        title: e['title'],
        author: e['authors'].isNotEmpty ? e['authors'][0]['name'] : 'Unknown',
        coverUrl: e['formats']['image/jpeg'] ?? '',
        epubUrl: e['formats']['application/epub+zip'],
        pdfUrl: e['formats']['application/pdf'],
      );
    }).toList();
  }
}
