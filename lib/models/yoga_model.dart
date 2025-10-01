// lib/models/yoga_model.dart
class YogaPose {
  final int id;
  final String title;
  final String imageUrl;
  final int timeSpentSeconds;

  YogaPose({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.timeSpentSeconds,
  });

  factory YogaPose.fromJson(Map<String, dynamic> json) {
    return YogaPose(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      timeSpentSeconds: json['time_spent_seconds'],
    );
  }
}

class DailyYoga {
  final int day;
  final List<YogaPose> poses;

  DailyYoga({required this.day, required this.poses});

  factory DailyYoga.fromJson(Map<String, dynamic> json) {
    var posesList = (json['poses'] as List)
        .map((pose) => YogaPose.fromJson(pose))
        .toList();
    return DailyYoga(day: json['day'], poses: posesList);
  }
}

class YogaPlan {
  final int id;
  final String name;
  final String category;
  final int days;
  final List<DailyYoga> dailySchedule;

  YogaPlan({
    required this.id,
    required this.name,
    required this.category,
    required this.days,
    required this.dailySchedule,
  });

  factory YogaPlan.fromJson(Map<String, dynamic> json) {
    var scheduleList = (json['daily_schedule'] as List)
        .map((day) => DailyYoga.fromJson(day))
        .toList();
    return YogaPlan(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      days: json['days'],
      dailySchedule: scheduleList,
    );
  }
}
