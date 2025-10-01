import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../models/plan_model.dart';

class PlanRepository {
  // filePath example: assets/plans/normal_plan.json
  Future<Plan> loadPlanFromAssets({
    required String id,
    required String name,
    required String filePath,
  }) async {
    final raw = await rootBundle.loadString(filePath);
    final decoded = json.decode(raw);

    Map<String, dynamic> jsonMap;

    if (decoded is List) {
      // If JSON is just an array, wrap it inside a map
      jsonMap = {
        "id": id,
        "name": name,
        "days": decoded,
      };
    } else if (decoded is Map<String, dynamic>) {
      // Already a map with "days"
      jsonMap = decoded;
      jsonMap["id"] = id;
      jsonMap["name"] = name;
    } else {
      throw Exception("Unsupported JSON format in $filePath");
    }

    return Plan.fromJson(jsonMap);
  }
}
