import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/res/data/nutrition_api.dart';
import '../models/nutrition_model.dart';

class NutritionVM extends GetxController {
  var nutritionList = <Nutrition>[].obs;
  var addedList = <Nutrition>[].obs; // Foods user added today
  var isLoading = false.obs;
  var error = "".obs;

  final _api = NutritionApi();

  @override
  void onInit() {
    super.onInit();
    _loadCache();
  }

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
    await _saveCache();
  }

  /// Remove food by index
  Future<void> removeFood(int index) async {
    if (index >= 0 && index < addedList.length) {
      addedList.removeAt(index);
      await _saveCache();
    }
  }

  /// Remove food by object
  Future<void> removeFoodItem(Nutrition food) async {
    addedList.remove(food);
    await _saveCache();
  }

  /// Clear all foods for today
  Future<void> clearAllFoods() async {
    addedList.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("nutrition_list");
    await prefs.remove("nutrition_date");
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // Save today's date
    await prefs.setString("nutrition_date", now.toIso8601String());

    // Save list as JSON strings
    final encoded = addedList.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList("nutrition_list", encoded);
  }

  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString("nutrition_date");

    if (savedDate != null) {
      final date = DateTime.parse(savedDate);
      final now = DateTime.now();

      // If same day → load cache
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        final savedList = prefs.getStringList("nutrition_list") ?? [];
        addedList.assignAll(
          savedList.map((e) => Nutrition.fromJson(jsonDecode(e))).toList(),
        );
      } else {
        // Expired → clear cache
        await prefs.remove("nutrition_list");
        await prefs.remove("nutrition_date");
      }
    }
  }
}
