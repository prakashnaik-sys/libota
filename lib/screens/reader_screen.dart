import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:epub_view/epub_view.dart';

class ReaderScreen extends StatefulWidget {
  final String source;
  final bool isLocal;

  const ReaderScreen({
    super.key,
    required this.source,
    this.isLocal = false,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  String? localPdfPath;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.source.endsWith('.pdf')) {
      _preparePdf();
    } else {
      loading = false;
    }
  }

  Future<void> _preparePdf() async {
    if (widget.isLocal) {
      localPdfPath = widget.source;
    } else {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      final response = await http.get(Uri.parse(widget.source));
      await file.writeAsBytes(response.bodyBytes);
      localPdfPath = file.path;
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // EPUB
    if (!widget.source.endsWith('.pdf')) {
      return Scaffold(
        appBar: AppBar(title: const Text('EPUB Reader')),
        body: EpubView(
          controller: EpubController(
            document: widget.isLocal
                ? EpubDocument.openFile(widget.source)
                : EpubDocument.openUrl(widget.source),
          ),
        ),
      );
    }

    // PDF
    if (loading || localPdfPath == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Reader')),
      body: PDFView(
        filePath: localPdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
      ),
    );
  }
}
