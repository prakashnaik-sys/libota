import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/utils/reading_progress.dart';

class EpubJsReader extends StatefulWidget {
  final String epubUrl;
  final String bookKey;

  const EpubJsReader({
    super.key,
    required this.epubUrl,
    required this.bookKey,
  });

  @override
  State<EpubJsReader> createState() => _EpubJsReaderState();
}

class _EpubJsReaderState extends State<EpubJsReader> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Progress',
        onMessageReceived: (msg) {
          ReadingProgress.saveChapter(widget.bookKey, 0, 0);
        },
      );
  }

  Future<String> _html() async {
    return '''
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/epubjs/dist/epub.min.js"></script>
</head>
<body style="margin:0">
<div id="viewer"></div>
<script>
var book = ePub("${widget.epubUrl}");
var rendition = book.renderTo("viewer", { width: "100%", height: "100%" });
rendition.display(localStorage.getItem("cfi"));

rendition.on("relocated", function(loc){
  localStorage.setItem("cfi", loc.start.cfi);
});
</script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reader")),
      body: WebViewWidget(
        controller: controller..loadHtmlString(_html().toString()),
      ),
    );
  }
}
