import 'package:flutter/material.dart';
import '../core/api/gutenberg_api.dart';
import '../core/api/open_library_api.dart';
import '../models/book.dart';

class BookProvider extends ChangeNotifier {
  List<Book> books = [];
  bool loading = false;
  bool hasMore = true;

  int _page = 1;
  String _query = '';

  // HOME (Trending)
  Future<void> loadInitialHome() async {
    books.clear();
    _page = 1;
    hasMore = true;
    await _loadHome();
  }

  Future<void> loadMoreHome() async {
    if (loading || !hasMore) return;
    await _loadHome();
  }

  Future<void> _loadHome() async {
    loading = true;
    notifyListeners();

    final newBooks = await GutenbergApi.getBooks(page: _page);

    if (newBooks.isEmpty) {
      hasMore = false;
    } else {
      books.addAll(newBooks);
      _page++;
    }

    loading = false;
    notifyListeners();
  }

  // SEARCH
  Future<void> search(String query) async {
    books.clear();
    _query = query;
    _page = 1;
    hasMore = true;
    await loadMoreSearch();
  }

  Future<void> loadMoreSearch() async {
    if (loading || !hasMore) return;

    loading = true;
    notifyListeners();

    final newBooks = await OpenLibraryApi.searchBooks(
      query: _query,
      page: _page,
    );

    if (newBooks.isEmpty) {
      hasMore = false;
    } else {
      books.addAll(newBooks);
      _page++;
    }

    loading = false;
    notifyListeners();
  }
}
