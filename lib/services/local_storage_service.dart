import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _highestDayKey = 'highest_day_completed'; // int
  static const _lastCompletedDateKey = 'last_completed_date'; // optional yyyy-mm-dd

  Future<int> getHighestDayCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestDayKey) ?? 0;
  }

  Future<void> setHighestDayCompleted(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highestDayKey, day);
  }

  Future<String?> getLastCompletedDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCompletedDateKey);
  }

  Future<void> setLastCompletedDate(String isoDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCompletedDateKey, isoDate);
  }
}
