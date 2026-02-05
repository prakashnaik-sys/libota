import 'package:flutter/material.dart';
import '../../core/api/openlibrary_api.dart';
import '../../features/details/book_details_screen.dart';
import '../../models/book.dart';
import '../../widgets/book_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Book>>? _results;

  String type = 'All';
  String sort = 'Most Relevant';
  String fileType = 'PDF';
  String language = 'All';
  String year = 'All';

  void _search() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _results = OpenLibraryApi.searchBooks(
        query: _controller.text,
        page: 1,
      );
    });
  }

  Widget _dropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.red, fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            isDense: true,
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Books')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Search',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            /// Search bar
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search by title, author, or ISBN',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),

            const SizedBox(height: 20),

            _dropdown('Type', type,
                ['All', 'Books', 'Authors'], (v) {
                  setState(() => type = v!);
                }),

            _dropdown('Sort by', sort,
                ['Most Relevant', 'Newest'], (v) {
                  setState(() => sort = v!);
                }),

            _dropdown('File type', fileType,
                ['PDF', 'EPUB'], (v) {
                  setState(() => fileType = v!);
                }),

            _dropdown('Language', language,
                ['All', 'English'], (v) {
                  setState(() => language = v!);
                }),

            _dropdown('Year Published', year,
                ['All', '2024', '2023'], (v) {
                  setState(() => year = v!);
                }),

            const SizedBox(height: 20),

            if (_results != null)
              FutureBuilder<List<Book>>(
                future: _results,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No results found.'));
                  }

                  final books = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: books.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.55,
                    ),
                    itemBuilder: (context, i) {
                      return BookTile(
                        book: books[i],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookDetailsScreen(book: books[i]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
