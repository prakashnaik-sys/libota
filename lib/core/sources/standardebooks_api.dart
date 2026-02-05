import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../../models/book.dart';

class StandardEbooksApi {
  static Future<List<Book>> fetch() async {
    final r = await http.get(Uri.parse('https://standardebooks.org/opds/all'));
    final doc = XmlDocument.parse(r.body);

    return doc.findAllElements('entry').map<Book>((e) {
      String epub = '', cover = '';

      for (final l in e.findAllElements('link')) {
        if (l.getAttribute('type') == 'application/epub+zip') epub = l.getAttribute('href') ?? '';
        if (l.getAttribute('rel') == 'http://opds-spec.org/image') cover = l.getAttribute('href') ?? '';
      }

      return Book(
        id: e.getElement('id')!.text,
        title: e.getElement('title')!.text,
        author: e.findAllElements('name').isNotEmpty
            ? e.findAllElements('name').first.text
            : 'Unknown',
        coverUrl: cover,
        epubUrl: epub,
      );
    }).toList();
  }
}
