import 'package:flutter/material.dart';
import 'package:libota/models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookTile({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.68, // slightly smaller
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                book.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.menu_book),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
