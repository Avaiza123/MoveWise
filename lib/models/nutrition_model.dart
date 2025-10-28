class Nutrition {
  final String name;
  final double servingSizeG;
  final double fat;
  final double carbohydrates;
  final double sugar;
  final double fiber;
  double calories;

  Nutrition({
    required this.name,
    required this.servingSizeG,
    required this.fat,
    required this.carbohydrates,
    required this.sugar,
    required this.fiber,
    double? calories,
  }) : calories = calories ?? calculateCalories(fat: fat, carbs: carbohydrates, fiber: fiber);

  /// Safely parse dynamic value to double
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Create Nutrition object from JSON
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    double fat = parseDouble(json['fat_total_g']);
    double carbs = parseDouble(json['carbohydrates_total_g']);
    double fiber = parseDouble(json['fiber_g']);
    double sugar = parseDouble(json['sugar_g']);

    return Nutrition(
      name: json['name'] ?? '',
      servingSizeG: parseDouble(json['serving_size_g']),
      fat: fat,
      carbohydrates: carbs,
      sugar: sugar,
      fiber: fiber,
      calories: calculateCalories(fat: fat, carbs: carbs, fiber: fiber),
    );
  }

  /// Convert Nutrition object to JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'serving_size_g': servingSizeG,
    'fat_total_g': fat,
    'carbohydrates_total_g': carbohydrates,
    'sugar_g': sugar,
    'fiber_g': fiber,
    'calories': calories,
  };

  /// Calculate calories: fat * 9 + (carbs - fiber) * 4
  static double calculateCalories({
    required double fat,
    required double carbs,
    double fiber = 0,
  }) {
    double netCarbs = carbs - fiber;
    if (netCarbs < 0) netCarbs = 0;
    return (fat * 9) + (netCarbs * 4);
  }
}
