import 'exercise_model.dart';

class Plan {
  final String name;
  final String category;
  final int days;
  final List<Day> dailySchedule;
  final bool isYoga; // ✅ add this

  Plan({
    required this.name,
    required this.category,
    required this.days,
    required this.dailySchedule,
    this.isYoga = false, // ✅ default false
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      name: json['name'] ?? 'Unnamed Plan',
      category: json['category'] ?? '',
      days: json['days'] ?? 0,
      dailySchedule: (json['daily_schedule'] as List<dynamic>?)
          ?.map((d) => Day.fromJson(d))
          .toList() ??
          [],
      isYoga: json['category'] != null &&
          (json['category'] as String).toLowerCase() == 'yoga',
      // ✅ mark as yoga if category is 'yoga'
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
      );
    } else {
      return Day(day: json['day'] ?? 0, exercises: []);
    }
  }
}
