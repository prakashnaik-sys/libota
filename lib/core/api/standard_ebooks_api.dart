class StandardEbooksApi {
  static Future<String?> findEpub(String title) async {
    try {
      return 'https://standardebooks.org/ebooks?query=${Uri.encodeComponent(title)}';
    } catch (_) {
      return null;
    }
  }
}
