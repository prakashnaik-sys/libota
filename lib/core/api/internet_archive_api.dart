class InternetArchiveApi {
  static Future<String?> findBorrowLink(String title) async {
    try {
      return 'https://openlibrary.org/search?q=${Uri.encodeComponent(title)}';
    } catch (_) {
      return null;
    }
  }
}
