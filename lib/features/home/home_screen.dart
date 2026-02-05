import 'package:flutter/material.dart';
import '../../core/api/gutenberg_api.dart';
import '../../models/book.dart';
import '../../widgets/book_tile.dart';
import '../details/book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();

  final List<Book> _books = [];
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();

    _controller.addListener(() {
      if (_controller.position.pixels >
              _controller.position.maxScrollExtent - 300 &&
          !_loading &&
          _hasMore) {
        _load();
      }
    });
  }

  Future<void> _load({bool refresh = false}) async {
    if (_loading) return;
    setState(() => _loading = true);

    if (refresh) {
      _books.clear();
      _page = 1;
      _hasMore = true;
      _error = null;
    }

    try {
      final result = await GutenbergApi.getBooks(page: _page);
      if (result.isEmpty) {
        _hasMore = false;
      } else {
        _books.addAll(result);
        _page++;
      }
    } catch (e) {
      setState(() => _error = "Failed to load books. Please try again.");
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LibOTA'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _load(refresh: true),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildBookGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookGrid() {
    if (_books.isEmpty && _loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(child: Text(_error!));
    } else if (_books.isEmpty) {
      return const Center(child: Text("No trending books found."));
    }

    return GridView.builder(
      controller: _controller,
      itemCount: _books.length + (_hasMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.52,
      ),
      itemBuilder: (context, i) {
        if (i >= _books.length) {
          return _hasMore ? const Center(child: CircularProgressIndicator()) : const Center(child: Text("No more books"));
        }

        final book = _books[i];

        return BookTile(
          book: book,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailsScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }
}
