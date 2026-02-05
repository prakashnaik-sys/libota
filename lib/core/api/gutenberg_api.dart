import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:libota/models/book.dart';

class GutenbergApi {
  static Future<List<Book>> getBooks({int page = 1}) async {
    final res = await http.get(Uri.parse(
        'https://gutendex.com/books/?page=$page'));

    final data = jsonDecode(res.body);
    final List results = data['results'];

    return results.map<Book>((e) {
      return Book(
        id: e['id'].toString(),
        title: e['title'],
        author: e['authors'].isNotEmpty
            ? e['authors'][0]['name']
            : 'Unknown',
        coverUrl: e['formats']['image/jpeg'] ?? '',
        epubUrl: e['formats']['application/epub+zip'],
        pdfUrl: e['formats']['application/pdf'],
      );
    }).toList();
  }
}
