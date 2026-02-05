import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryStorage {
  static const _key = 'my_library';

  static Future<void> addBook({
    required String bookKey,
    required String title,
    required String coverUrl,
    required String filePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    final data = jsonEncode({
      'key': bookKey,
      'title': title,
      'coverUrl': coverUrl,
      'filePath': filePath,
    });

    if (!list.contains(data)) {
      list.add(data);
      await prefs.setStringList(_key, list);
    }
  }

  static Future<List<Map<String, dynamic>>> getBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> removeBook(String bookKey) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    list.removeWhere((e) => jsonDecode(e)['key'] == bookKey);
    await prefs.setStringList(_key, list);
  }
}
