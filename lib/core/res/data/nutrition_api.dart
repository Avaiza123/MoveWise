import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/nutrition_model.dart';
//
// class NutritionApi {
//   static const String appId = "2f69a591";
//   static const String apiKey = "90ba34e8ad5b593b67aca0acaf204cd0";
//
//   /// Search nutrition using natural language query
//   Future<List<Nutrition>> fetchNutrition(String query) async {
//     final url = Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
//
//     final response = await http.post(
//       url,
//       headers: {
//         "x-app-id": appId,
//         "x-app-key": apiKey,
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({"query": query}),
//     );
//
//     if (response.statusCode != 200) {
//       print("Nutritionix API Error: ${response.body}");
//       return [];
//     }
//
//     final data = jsonDecode(response.body);
//     final List foods = data['foods'] ?? [];
//
//     return foods.map((f) => Nutrition.fromJson(f)).toList();
//   }
// }


class NutritionApi {
  static const String apiKey = "u2g6SlyRbdylksVrXyJrQQ==HDjeaWSrOsy9bSmk";

  Future<List<Nutrition>> fetchNutrition(String query) async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/nutrition?query=$query');

    final response = await http.get(
      url,
      headers: {"X-Api-Key": apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Nutrition.fromJson(item)).toList();
    } else {
      print("Nutrition API Error: ${response.statusCode} - ${response.body}");
      return [];
    }
  }
}