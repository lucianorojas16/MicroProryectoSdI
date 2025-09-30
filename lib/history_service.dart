import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _winsKey = 'totalWins';
  static const String _lossesKey = 'totalLosses';

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  static Future<Map<String, int>> loadHistory() async {
    final prefs = await _prefs;
    return {
      'wins': prefs.getInt(_winsKey) ?? 0,
      'losses': prefs.getInt(_lossesKey) ?? 0,
    };
  }

  static Future<void> incrementWins() async {
    final prefs = await _prefs;
    int current = prefs.getInt(_winsKey) ?? 0;
    await prefs.setInt(_winsKey, current + 1);
  }

  static Future<void> incrementLosses() async {
    final prefs = await _prefs;
    int current = prefs.getInt(_lossesKey) ?? 0;
    await prefs.setInt(_lossesKey, current + 1);
  }
}