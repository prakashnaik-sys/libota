import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
BookRepository.search(query);


class _SearchScreenState extends State<SearchScreen> {
  final _controller = ScrollController();
  final _text = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 300) {
        context.read<BookProvider>().loadMoreSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _text,
              onSubmitted: (q) =>
                  context.read<BookProvider>().search(q),
              decoration: const InputDecoration(
                hintText: 'Search books…',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context
                  .read<BookProvider>()
                  .search(_text.text),
              child: GridView.builder(
                controller: _controller,
                padding: const EdgeInsets.all(12),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                ),
                itemCount:
                provider.books.length +
                    (provider.hasMore ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i < provider.books.length) {
                    return BookCard(book: provider.books[i]);
                  }
                  return const Center(
                      child: CircularProgressIndicator());
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
