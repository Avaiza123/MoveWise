import 'exercise_model.dart';

class Plan {
  final int? id; // ✅ Unique ID for identifying plan
  final String name;
  final String category;
  final int days;
  final List<Day> dailySchedule;
  final bool isYoga;
  int currentDay; // ✅ Track user progress in this plan

  Plan({
    required this.id,
    required this.name,
    required this.category,
    required this.days,
    required this.dailySchedule,
    this.isYoga = false,
    this.currentDay = 0, // starts at 0 = not started
  });

  factory Plan.fromJson(Map<String, dynamic> json, {required int id}) {
    final category = json['category'] ?? '';
    return Plan(
      id: id,
      name: json['name'] ?? 'Unnamed Plan',
      category: category,
      days: json['days'] ?? 0,
      dailySchedule: (json['daily_schedule'] as List<dynamic>?)
          ?.map((d) => Day.fromJson(d as Map<String, dynamic>))
          .toList() ??
          [],
      isYoga: category.toLowerCase() == 'yoga',
      currentDay: 0,
    );
  }
}

class Day {
  final int day;
  final List<Exercise> exercises;
  final bool isRest;

  Day({
    required this.day,
    required this.exercises,
    this.isRest = false,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    final workout = json['workout'];
    if (workout is String && workout.toLowerCase() == 'rest day') {
      return Day(day: json['day'] ?? 0, exercises: [], isRest: true);
    } else if (workout is List) {
      return Day(
        day: json['day'] ?? 0,
        exercises: workout
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList(),
        isRest: false,
      );
    } else {
      return Day(day: json['day'] ?? 0, exercises: [], isRest: false);
    }
  }
}
