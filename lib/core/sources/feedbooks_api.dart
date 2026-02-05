import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../../models/book.dart';

class FeedbooksApi {
  static Future<List<Book>> fetch() async {
    try {
      final r = await http.get(Uri.parse(
          'https://catalog.feedbooks.com/publicdomain/catalog.atom'));

      if (r.statusCode != 200) {
        return [];
      }

      final doc = XmlDocument.parse(r.body);

      return doc.findAllElements('entry').map<Book>((e) {
        String epub = '', cover = '';
        for (final l in e.findAllElements('link')) {
          final type = l.getAttribute('type');
          final href = l.getAttribute('href') ?? '';
          
          if (type == 'application/epub+zip') {
            epub = href;
          } else if (type == 'image/jpeg' || type == 'image/png') {
            cover = href;
          }
        }

        return Book(
          id: e.getElement('id')?.text ?? '',
          title: e.getElement('title')?.text ?? 'Unknown Title',
          author: e.findAllElements('name').isNotEmpty
              ? e.findAllElements('name').first.text
              : 'Unknown Author',
          coverUrl: cover,
          epubUrl: epub,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
