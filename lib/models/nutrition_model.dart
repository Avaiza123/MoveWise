class Nutrition {
  final String name;
  final int servingQty;
  final String servingUnit;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final double sugar;
  final double fiber;

  Nutrition({
    required this.name,
    required this.servingQty,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.sugar,
    required this.fiber,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      name: json['food_name'] ?? '',
      servingQty: (json['serving_qty'] ?? 0).toInt(),
      servingUnit: json['serving_unit'] ?? '',
      calories: (json['nf_calories'] ?? 0).toDouble(),
      protein: (json['nf_protein'] ?? 0).toDouble(),
      fat: (json['nf_total_fat'] ?? 0).toDouble(),
      carbohydrates: (json['nf_total_carbohydrate'] ?? 0).toDouble(),
      sugar: (json['nf_sugars'] ?? 0).toDouble(),
      fiber: (json['nf_dietary_fiber'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_name': name,
      'serving_qty': servingQty,
      'serving_unit': servingUnit,
      'nf_calories': calories,
      'nf_protein': protein,
      'nf_total_fat': fat,
      'nf_total_carbohydrate': carbohydrates,
      'nf_sugars': sugar,
      'nf_dietary_fiber': fiber,
    };
  }
}
