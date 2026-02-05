import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  final books = await BookRepository.trending(page);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 300) {
        context.read<BookProvider>().loadMoreHome();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BookProvider>().loadInitialHome();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('LibOTA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<BookProvider>().loadInitialHome(),
        child: GridView.builder(
          controller: _controller,
          padding: const EdgeInsets.all(12),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
          ),
          itemCount:
          provider.books.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i < provider.books.length) {
              return BookCard(book: provider.books[i]);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
