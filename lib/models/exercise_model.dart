class Exercise {
  final int exerciseId;
  final String title;
  final int sets;
  final int reps;
  final String imageUrl;

  Exercise({
    required this.exerciseId,
    required this.title,
    required this.sets,
    required this.reps,
    required this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exercise_id'],
      title: json['title'],
      sets: json['sets'],
      reps: json['reps'],
      imageUrl: json['image_url'],
    );
  }
}
