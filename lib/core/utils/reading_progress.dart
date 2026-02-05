import 'package:shared_preferences/shared_preferences.dart';

class ReadingProgress {
  static Future<void> saveChapter(
      String bookKey, int chapter, int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ch_$bookKey', chapter);
    await prefs.setInt('tot_$bookKey', total);
  }

  static Future<double> loadPercent(String bookKey) async {
    final prefs = await SharedPreferences.getInstance();
    final ch = prefs.getInt('ch_$bookKey') ?? 0;
    final tot = prefs.getInt('tot_$bookKey') ?? 1;
    return (ch / tot) * 100;
  }
}
