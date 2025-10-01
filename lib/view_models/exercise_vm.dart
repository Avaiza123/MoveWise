import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/exercise_model.dart';

class ExerciseViewModel extends GetxController {
  /// Reactive state
  var exercises = <Exercise>[].obs; // current day plan exercises
  var currentDay = 1.obs;           // tracks user progress (1–30 days)
  var isLoading = false.obs;

  /// Initialize when controller is created
  @override
  void onInit() {
    super.onInit();
    _loadProgress();
  }

  /// Save progress (day number) to cache
  Future<void> saveProgress(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('completed_day', day);
    currentDay.value = day;
  }

  /// Load progress (last completed day) from cache
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    currentDay.value = prefs.getInt('completed_day') ?? 1; // default day 1
  }

  /// Called when user presses "Done" after finishing today’s exercises
  Future<void> markTodayComplete() async {
    if (currentDay.value < 30) {
      await saveProgress(currentDay.value + 1);
    }
  }

  /// Load exercises for a specific plan (My Plan, Easier, Harder, Yoga)
  Future<void> loadExercisesForPlan(String planKey) async {
    try {
      isLoading.value = true;

      // file path e.g. assets/exercises/my_plan_day1.json
      final filePath = 'assets/exercises/${planKey}_day${currentDay.value}.json';

      final String response = await rootBundle.loadString(filePath);
      final List<dynamic> data = json.decode(response);

      exercises.value = data.map((e) => Exercise.fromJson(e)).toList();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      exercises.clear();
      print("❌ Error loading plan: $e");
    }
  }

  /// For BMI-based auto-plan (optional, can be removed if not needed)
  String _getBmiCategory(double bmi) {
    if (bmi < 16) return 'severely_underweight';
    if (bmi < 17) return 'moderately_underweight';
    if (bmi < 18.5) return 'mild_thinness';
    if (bmi < 25) return 'normal';
    if (bmi < 30) return 'overweight';
    if (bmi < 35) return 'obese1';
    if (bmi < 40) return 'obese2';
    return 'obese3';
  }

  Future<List<Exercise>> getExercisesForCachedBmi() async {
    final prefs = await SharedPreferences.getInstance();
    final double? bmi = prefs.getDouble('bmi');
    if (bmi == null) return [];

    final category = _getBmiCategory(bmi);
    final String response =
    await rootBundle.loadString('assets/exercises/$category.json');
    final data = json.decode(response) as List;

    return data.map((json) => Exercise.fromJson(json)).toList();
  }
}
