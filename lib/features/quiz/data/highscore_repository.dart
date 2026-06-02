import 'package:shared_preferences/shared_preferences.dart';

class HighscoreRepository {
  static const String _prefix = 'highscore_';

  Future<int?> getHighscore(String categoryKey) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('$_prefix$categoryKey');
    return value;
  }

  Future<bool> saveIfHighscore(String categoryKey, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$categoryKey';
    final current = prefs.getInt(key);
    if (current == null || score > current) {
      await prefs.setInt(key, score);
      return true;
    }
    return false;
  }
}
