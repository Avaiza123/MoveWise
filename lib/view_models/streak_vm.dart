import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class StreakVM extends GetxController {
  final box = GetStorage();
  final streak = 0.obs;
  final lastActivityDate = Rxn<DateTime>();

  static const String _streakKey = "streak_day";
  static const String _lastDateKey = "streak_date";

  @override
  void onInit() {
    super.onInit();
    _initializeStreak();
  }

  /// ✅ Initialize streak values and verify continuity
  void _initializeStreak() {
    final savedStreak = box.read(_streakKey) ?? 0;
    final lastDateString = box.read(_lastDateKey);

    DateTime? lastDate;
    if (lastDateString != null) {
      lastDate = DateTime.tryParse(lastDateString);
    }

    streak.value = savedStreak;
    lastActivityDate.value = lastDate;

    _validateStreakContinuity();
  }

  /// ✅ Ensure streak continuity (reset if user missed >1 day)
  void _validateStreakContinuity() {
    final lastDate = lastActivityDate.value;
    if (lastDate == null) return;

    final now = DateTime.now();
    final daysDifference = now.difference(
      DateTime(lastDate.year, lastDate.month, lastDate.day),
    ).inDays;

    // User missed more than 1 day → reset streak
    if (daysDifference > 1) {
      resetStreak();
    }
  }

  /// ✅ Called when user completes a workout / daily goal
  void markExerciseDoneToday() {
    final today = DateTime.now();
    final formattedToday = DateFormat('yyyy-MM-dd').format(today);
    final lastDateStr = box.read(_lastDateKey) ?? "";

    if (lastDateStr != formattedToday) {
      // Increment streak
      streak.value += 1;
      box.write(_streakKey, streak.value);
      box.write(_lastDateKey, formattedToday);

      lastActivityDate.value = today;

      // Optional: Trigger celebration or notification
      _showStreakCelebration();
    }
  }

  /// ✅ Reset streak completely
  void resetStreak() {
    streak.value = 0;
    lastActivityDate.value = null;
    box.write(_streakKey, 0);
    box.remove(_lastDateKey);
  }

  /// 🎉 Optional: Show animation, emoji, or toast when streak increases
  void _showStreakCelebration() {
    if (streak.value > 0) {
      Get.snackbar(
        "🔥 Keep Going!",
        "You're on a ${streak.value}-day streak!",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF111111).withOpacity(0.8),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  /// ✅ Human-readable last activity info
  String get lastActiveText {
    final date = lastActivityDate.value;
    if (date == null) return "No activity yet";
    final formatted = DateFormat('MMM d, yyyy').format(date);
    return "Last activity: $formatted";
  }
  RxInt get streakCount => streak;

}
