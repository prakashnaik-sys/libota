class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String? epubUrl;
  final String? pdfUrl;
  final String? internetArchiveUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    this.epubUrl,
    this.pdfUrl,
    this.internetArchiveUrl,
  });
}
