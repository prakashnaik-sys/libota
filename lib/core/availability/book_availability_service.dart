import 'package:libota/models/book.dart';
import '../models/availability_result.dart';
import '../models/availability_source.dart';

class BookAvailabilityService {
  static Future<List<AvailabilityResult>> check(Book book) async {
    final List<AvailabilityResult> results = [];

    /// ✅ INTERNET ARCHIVE
    if (book.internetArchiveUrl != null &&
        book.internetArchiveUrl!.isNotEmpty) {
      results.add(
        AvailabilityResult(
          source: AvailabilitySource.internetArchive,
          label: 'Borrow to read (Internet Archive)',
          url: book.internetArchiveUrl!,
        ),
      );
    }

    /// Gutenberg / EPUB
    if (book.epubUrl != null && book.epubUrl!.isNotEmpty) {
      results.add(
        AvailabilityResult(
          source: AvailabilitySource.gutenberg,
          label: 'Read free EPUB',
          url: book.epubUrl!,
        ),
      );
    }

    /// PDF
    if (book.pdfUrl != null && book.pdfUrl!.isNotEmpty) {
      results.add(
        AvailabilityResult(
          source: AvailabilitySource.external,
          label: 'Read PDF',
          url: book.pdfUrl!,
        ),
      );
    }

    return results;
  }
}
