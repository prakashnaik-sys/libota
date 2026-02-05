import 'package:http/http.dart' as http;

class KavitaProgressApi {
  final String baseUrl;
  final String token;

  KavitaProgressApi(this.baseUrl, this.token);

  Future<void> syncProgress(int bookId, double percent) async {
    await http.post(
      Uri.parse('$baseUrl/api/reader/progress'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: '{"bookId":$bookId,"progress":$percent}',
    );
  }
}
