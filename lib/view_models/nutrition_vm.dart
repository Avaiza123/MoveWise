import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/res/data/nutrition_api.dart';
import '../models/nutrition_model.dart';

class NutritionVM extends GetxController {
  var nutritionList = <Nutrition>[].obs;
  var addedList = <Nutrition>[].obs; // Foods user added today
  var isLoading = false.obs;
  var error = "".obs;

  final _api = NutritionApi();

  /// Daily calorie tracking
  final int dailyCalorieLimit = 3000;
  var totalCalories = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCache();
  }

  /// Fetch nutrition info from API
  Future<void> getNutrition(String query) async {
    try {
      isLoading.value = true;
      error.value = "";
      final result = await _api.fetchNutrition(query);
      nutritionList.assignAll(result);
    } catch (e) {
      error.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a food to today's cache
  Future<void> addFood(Nutrition food) async {
    addedList.add(food);
    _recalculateCalories();
    await _saveCache();
  }

  /// Remove food by index
  Future<void> removeFood(int index) async {
    if (index >= 0 && index < addedList.length) {
      addedList.removeAt(index);
      _recalculateCalories();
      await _saveCache();
    }
  }

  /// Remove food by object
  Future<void> removeFoodItem(Nutrition food) async {
    addedList.remove(food);
    _recalculateCalories();
    await _saveCache();
  }

  /// Clear all foods for today
  Future<void> clearAllFoods() async {
    addedList.clear();
    totalCalories.value = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("nutrition_list");
    await prefs.remove("nutrition_date");
    await prefs.remove("total_calories");
  }

  /// Save current added foods and calories
  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await prefs.setString("nutrition_date", now.toIso8601String());

    final encoded = addedList.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList("nutrition_list", encoded);

    await prefs.setInt("total_calories", totalCalories.value);
  }

  /// Load saved cache if the date is today
  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString("nutrition_date");

    if (savedDate != null) {
      final date = DateTime.parse(savedDate);
      final now = DateTime.now();

      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        final savedList = prefs.getStringList("nutrition_list") ?? [];
        addedList.assignAll(savedList.map((e) => Nutrition.fromJson(jsonDecode(e))).toList());

        // Recalculate total calories after loading
        _recalculateCalories();
      } else {
        // Expired → clear cache
        await prefs.remove("nutrition_list");
        await prefs.remove("nutrition_date");
        await prefs.remove("total_calories");
      }
    }
  }

  /// Recalculate total calories
  void _recalculateCalories() {
    totalCalories.value = addedList.fold(
      0,
          (sum, item) => sum + item.calories.toInt(),
    );
  }

  /// 🔹 Progress for UI (0 → 1)
  double get calorieProgress =>
      (totalCalories.value / dailyCalorieLimit).clamp(0.0, 1.0);

  /// 🔹 Get fill color for circular bowl
  // Green if <60%, Orange <90%, Red ≥90%
  static Color progressColor(double progress) {
    if (progress < 0.6) return AppColors.green.withOpacity(0.8);
    if (progress < 0.9) return AppColors.orange.withOpacity(0.7);
    return AppColors.red.withOpacity(0.7);
  }
}
