import 'package:flutter/material.dart';
import '../../core/api/openlibrary_api.dart';
import '../../core/models/book.dart';
import '../../widgets/book_tile.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: OpenLibraryApi.trending(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final books = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.63,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: books.length,
          itemBuilder: (_, i) {
            return BookTile(
              title: books[i].title,
              coverUrl: books[i].coverUrl,
            );
          },
        );
      },
    );
  }
}
