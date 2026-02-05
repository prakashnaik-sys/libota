import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfReaderScreen extends StatelessWidget {
  final String filePath;

  const PdfReaderScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final controller = PdfController(
      document: PdfDocument.openFile(filePath),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Reader')),
      body: PdfView(
        controller: controller,
      ),
    );
  }
}
