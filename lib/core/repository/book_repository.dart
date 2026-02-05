import '../sources/gutendex_api.dart';
import '../sources/feedbooks_api.dart';
import '../sources/standardebooks_api.dart';
import '../sources/google_books_api.dart';
import '../../models/book.dart';

class BookRepository {
  static Future<List<Book>> trending(int page) async {
    final g = await GutendexApi.fetch(page);
    final f = await FeedbooksApi.fetch();
    final s = await StandardEbooksApi.fetch();

    return [...g, ...f, ...s];
  }

  static Future<List<Book>> search(String q) async {
    final google = await GoogleBooksApi.search(q);
    return google;
  }
}
