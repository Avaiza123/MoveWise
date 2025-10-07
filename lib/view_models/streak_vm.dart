import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StreakVM extends GetxController {
  final box = GetStorage();
  var streak = 0.obs;

  static const String _streakKey = "streak_day";
  static const String _lastDateKey = "streak_date";

  @override
  void onInit() {
    super.onInit();
    _checkStreakStatus();
  }

  /// ✅ Load streak and reset if missed a day
  void _checkStreakStatus() {
    final lastDateString = box.read(_lastDateKey);
    if (lastDateString != null) {
      final lastDate = DateTime.tryParse(lastDateString);
      if (lastDate != null) {
        final now = DateTime.now();
        final difference = now.difference(lastDate).inHours;

        // If more than 24 hours since last activity -> reset
        if (difference > 24) {
          resetStreak();
          return;
        }
      }
    }
    streak.value = box.read(_streakKey) ?? 0;
  }

  /// ✅ Called when user completes *any* exercise/day in *any* plan
  void markExerciseDoneToday() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = box.read(_lastDateKey) ?? "";

    // Only increment once per calendar day
    if (today != lastDate) {
      streak.value += 1;
      box.write(_streakKey, streak.value);
      box.write(_lastDateKey, today);
    }
  }

  /// ✅ Reset streak (user missed 24+ hours)
  void resetStreak() {
    streak.value = 0;
    box.write(_streakKey, 0);
    box.write(_lastDateKey, "");
  }
}
