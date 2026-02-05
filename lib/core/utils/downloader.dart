import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Downloader {
  static Future<String> downloadEpub(String url, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.epub');

    final response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);

    return file.path;
  }
}
