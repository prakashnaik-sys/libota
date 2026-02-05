import 'package:flutter/material.dart';
import '../core/models/book.dart';
import '../features/reader/reader_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.coverUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: book.coverUrl,
              width: 50,
              height: 75,
              fit: BoxFit.cover,
              placeholder: (_, __) => const SizedBox(
                width: 50,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
            )
          : const Icon(Icons.book, size: 50),
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReaderScreen(url: book.readUrl),
          ),
        );
      },
    );
  }
}
