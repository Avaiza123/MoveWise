class Exercise {
  final int exerciseId;
  final String title;
  final int sets;
  final int reps;
  final String animationUrl;
  final int duration; // ✅ for yoga poses in seconds, 0 if not applicable


  Exercise({
    required this.exerciseId,
    required this.title,
    required this.sets,
    required this.reps,
    required this.animationUrl,
    this.duration = 0,

  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exercise_id'] ?? 0,
     title: json['title'] ?? '',
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      animationUrl: json['image_url'] ?? '',
      duration: json['duration'] ?? 0,

    );
  }
}
class Pose {
  final int id;
  final String title;
  final String imageUrl;
  final int timeSpentSeconds;

  Pose({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.timeSpentSeconds,
  });

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'], // ✅ must match JSON key
      timeSpentSeconds: json['time_spent_seconds'],
    );
  }
}
