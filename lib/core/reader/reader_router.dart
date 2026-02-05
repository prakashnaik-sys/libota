import 'package:flutter/material.dart';
import '../../features/reader/epub_reader.dart';
import '../../features/reader/pdf_reader.dart';
import '../../features/reader/epubjs_reader.dart';

class ReaderRouter {
  static Widget open({
    required String filePathOrUrl,
    required String bookKey,
  }) {
    final lower = filePathOrUrl.toLowerCase();

    if (lower.endsWith('.epub')) {
      return EpubReaderScreen(
        filePath: filePathOrUrl,
        bookKey: bookKey,
      );
    }

    if (lower.endsWith('.pdf')) {
      return PdfReaderScreen(filePath: filePathOrUrl);
    }

    // MOBI / complex EPUB fallback
    return EpubJsReader(epubUrl: filePathOrUrl);
  }
}
