import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_model.dart';
import '../models/plan_model.dart';

class PlanVM extends GetxController {
  var loading = false.obs;
  var plans = <Plan>[].obs;
  var currentDayIndices = <int>[].obs; // Track current day per plan
  final _storage = GetStorage(); // ✅ Local persistent cache

  // 🔹 Map plan ID → JSON file
  final Map<int, String> planFiles = {
    1: 'assets/json/Severely_Underweight.json',
    2: 'assets/json/Moderately_Underweight.json',
    3: 'assets/json/Mild_Thinness.json',
    4: 'assets/json/Normal.json',
    5: 'assets/json/Overweight.json',
    6: 'assets/json/Obese_1.json',
    7: 'assets/json/Obese_2.json',
    8: 'assets/json/Obese_3.json',
    9: 'assets/json/yoga_30_days_plan.json',
  };

  // 🔹 Convert BMI → category ID
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

  /// 🔹 Load the user's recommended plans (3 workout + 1 yoga)
  Future<void> loadPlansForUser(String uid) async {
    try {
      loading.value = true;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) throw Exception("User not found");

      final data = doc.data();
      if (data == null ||
          data['profile'] == null ||
          data['profile']['bmi'] == null) {
        throw Exception("No BMI found for user");
      }

      double bmi = double.parse(data['profile']['bmi']);
      int currentId = _bmiCategoryId(bmi);

      List<int> selectedIds = [];
      if (currentId == 1) {
        selectedIds = [1, 2, 3];
      } else if (currentId == 8) {
        selectedIds = [6, 7, 8];
      } else {
        selectedIds = [currentId - 1, currentId, currentId + 1];
      }

      selectedIds.add(9); // Always add Yoga last

      // 🔹 Load and cache plans
      plans.clear();
      currentDayIndices.clear();

      for (var id in selectedIds) {
        final path = planFiles[id]!;
        final jsonString = await rootBundle.loadString(path);
        final jsonMap = json.decode(jsonString);

        // ✅ pass ID to Plan.fromJson
        final plan = Plan.fromJson(jsonMap, id: id);

        // ✅ restore progress
        final savedDay = _storage.read('plan_${id}_day') ?? 0;
        plan.currentDay = savedDay;

        plans.add(plan);
        currentDayIndices.add(savedDay);
      }
    } catch (e) {
      print("Error loading plans: $e");
    } finally {
      loading.value = false;
    }
  }

  /// 🔹 Get exercises for the current day of a given plan
  List<Exercise> exercisesForCurrentDay(int planIndex) {
    if (plans.isEmpty || planIndex >= plans.length) return [];
    final dayIndex = currentDayIndices[planIndex];
    if (dayIndex >= plans[planIndex].dailySchedule.length) return [];
    return plans[planIndex].dailySchedule[dayIndex].exercises;
  }

  /// 🔹 Start a plan at Day 1
  void startPlan(int planIndex) {
    if (planIndex >= plans.length) return;
    plans[planIndex].currentDay = 1;
    currentDayIndices[planIndex] = 0;
    _saveProgress(planIndex);
    plans.refresh();
  }

  /// 🔹 Mark current day complete
  void markCurrentDayDone(int planIndex) {
    if (planIndex >= plans.length) return;
    final plan = plans[planIndex];
    final nextDay = plan.currentDay + 1;

    if (nextDay <= plan.dailySchedule.length) {
      plan.currentDay = nextDay;
      currentDayIndices[planIndex] = nextDay - 1;
      _saveProgress(planIndex);
      plans.refresh();
    }
  }

  /// 🔹 Save progress locally
  void _saveProgress(int planIndex) {
    final plan = plans[planIndex];
    _storage.write('plan_${plan.id}_day', plan.currentDay);
  }

  /// 🔹 Reset a plan to Day 1
  void resetDayIndex(int planIndex) {
    if (planIndex >= 0 && planIndex < plans.length) {
      plans[planIndex].currentDay = 0;
      currentDayIndices[planIndex] = 0;
      _saveProgress(planIndex);
    }
  }
}
