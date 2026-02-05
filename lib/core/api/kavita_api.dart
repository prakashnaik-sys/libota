import 'dart:convert';
import 'package:http/http.dart' as http;

class KavitaBook {
  final int id;
  final String title;

  KavitaBook({required this.id, required this.title});
}

class KavitaApi {
  final String baseUrl;
  final String apiKey;

  KavitaApi(this.baseUrl, this.apiKey);

  Future<List<KavitaBook>> fetchBooks() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/library'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    final List data = json.decode(res.body);
    return data
        .map((b) => KavitaBook(id: b['id'], title: b['title']))
        .toList();
  }

  String downloadUrl(int bookId) =>
      '$baseUrl/api/book/$bookId/download';
}
