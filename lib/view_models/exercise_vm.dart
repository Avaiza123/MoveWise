import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/exercise_model.dart';

class ExerciseViewModel {
  List<Exercise> _allExercises = [];

  /// Load all exercises from local JSON files
  Future<void> loadExercises() async {
    // Load all category JSONs
    final categories = [
      'severely_underweight',
      'moderately_underweight',
      'mild_thinness',
      'normal',
      'overweight',
      'obese1',
      'obese2',
      'obese3',
    ];

    _allExercises = [];

    for (String category in categories) {
      final String response =
      await rootBundle.loadString('assets/exercises/$category.json');
      final data = json.decode(response) as List;
      _allExercises.addAll(data.map((json) => Exercise.fromJson(json)));
    }
  }

  /// Determine BMI category string
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

  /// Get exercises based on BMI saved in cache
  Future<List<Exercise>> getExercisesForCachedBmi() async {
    final prefs = await SharedPreferences.getInstance();
    final double? bmi = prefs.getDouble('bmi');

    if (bmi == null) return []; // no bmi saved yet

    final category = _getBmiCategory(bmi);

    // Load JSON for this category only
    final String response =
    await rootBundle.loadString('assets/exercises/$category.json');
    final data = json.decode(response) as List;

    return data.map((json) => Exercise.fromJson(json)).toList();
  }
  Future<List<Exercise>> loadExercisesFromJson(String path) async {
    final data = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => Exercise.fromJson(e)).toList();
  }

}
