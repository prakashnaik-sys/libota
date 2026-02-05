import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ReaderScreen extends StatefulWidget {
  final String url;

  const ReaderScreen({super.key, required this.url});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  String? localPath;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    if (widget.url.endsWith('.epub') || widget.url.endsWith('.pdf')) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp');
      final res = await http.get(Uri.parse(widget.url));
      await file.writeAsBytes(res.bodyBytes);
      localPath = file.path;
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// EPUB
    if (widget.url.endsWith('.epub')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reader')),
        body: EpubView(
          controller: EpubController(
            document: EpubDocument.openFile(localPath!),
          ),
        ),
      );
    }

    /// PDF
    if (widget.url.endsWith('.pdf')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reader')),
        body: PDFView(filePath: localPath!),
      );
    }

    /// INTERNET ARCHIVE EMBEDDED READER
    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url)),
      ),
    );
  }
}
