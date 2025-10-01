import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_model.dart';
import '../models/plan_model.dart';

class PlanVM extends GetxController {
  var loading = false.obs;
  var plans = <Plan>[].obs; // Store multiple plans
  var currentDayIndices = <int>[].obs; // Track day index per plan

  // Map plan ID → JSON file
  final Map<int, String> planFiles = {
    1: 'assets/json/Severely_Underweight.json',
    2: 'assets/json/Moderately_Underweight.json',
    3: 'assets/json/Mild_Thinness.json',
    4: 'assets/json/Normal.json',
    5: 'assets/json/Overweight.json',
    6: 'assets/json/Obese_1.json',
    7: 'assets/json/Obese_2.json',
    8: 'assets/json/Obese_3.json',
    9: 'assets/json/yoga_30_days_plan.json', // Yoga
  };

  /// Convert BMI → plan ID
  int _bmiCategoryId(double bmi) {
    if (bmi < 16) return 1;
    if (bmi < 17) return 2;
    if (bmi < 18.5) return 3;
    if (bmi < 25) return 4;
    if (bmi < 30) return 5;
    if (bmi < 35) return 6;
    if (bmi < 40) return 7;
    return 8;
  }

  /// Load user plans: 3 exercise plans + 1 Yoga plan
  Future<void> loadPlansForUser(String uid) async {
    try {
      loading.value = true;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) throw Exception("User not found");

      final data = doc.data();
      if (data == null || data['profile'] == null || data['profile']['bmi'] == null) {
        throw Exception("No BMI found for user");
      }

      double bmi = double.parse(data['profile']['bmi']);
      int currentId = _bmiCategoryId(bmi);

      // Determine IDs for previous/current/next exercise plans
      List<int> selectedIds = [];
      if (currentId == 1) {
        selectedIds = [1, 2, 3];
      } else if (currentId == 8) {
        selectedIds = [6, 7, 8];
      } else {
        selectedIds = [currentId - 1, currentId, currentId + 1];
      }

      // Always add Yoga plan at the end
      selectedIds.add(9);

      // Load JSON files
      plans.clear();
      currentDayIndices.clear();
      for (var id in selectedIds) {
        final path = planFiles[id]!;
        final jsonString = await rootBundle.loadString(path);
        final jsonMap = json.decode(jsonString);
        plans.add(Plan.fromJson(jsonMap));
        currentDayIndices.add(0); // start at first day for each plan
      }
    } catch (e) {
      print("Error loading plans: $e");
    } finally {
      loading.value = false;
    }
  }

  /// Exercises for a given plan and its current day
  List<Exercise> exercisesForCurrentDay(int planIndex) {
    if (plans.isEmpty || planIndex >= plans.length) return [];
    final dayIndex = currentDayIndices[planIndex];
    if (dayIndex >= plans[planIndex].dailySchedule.length) return [];
    final day = plans[planIndex].dailySchedule[dayIndex];
    return day.exercises; // empty for rest days
  }

  /// Move to next day for a specific plan
  void markCurrentDayDone(int planIndex) {
    if (plans.isEmpty || planIndex >= plans.length) return;

    if (currentDayIndices[planIndex] < plans[planIndex].dailySchedule.length - 1) {
      currentDayIndices[planIndex]++;
    }
  }

  /// Reset current day for a plan (optional)
  void resetDayIndex(int planIndex) {
    if (planIndex >= 0 && planIndex < currentDayIndices.length) {
      currentDayIndices[planIndex] = 0;
    }
  }
}
