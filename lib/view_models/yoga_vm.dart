// lib/view_models/yoga_vm.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/yoga_model.dart';

class YogaVM extends GetxController {
  var yogaPlan = Rxn<YogaPlan>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadYogaPlan();
  }

  Future<void> loadYogaPlan() async {
    isLoading.value = true;
    try {
      final jsonData = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/json/yoga_30_days_plan.json'); // ✅ correct path
      yogaPlan.value = YogaPlan.fromJson(jsonDecode(jsonData));
    } catch (e) {
      print("Error loading yoga plan: $e");
    } finally {
      isLoading.value = false;
    }
  }



  /// Get exercises/poses for a specific day (0-based index)
  List<YogaPose> exercisesForDay(int dayIndex) {
    if (yogaPlan.value == null || yogaPlan.value!.dailySchedule.isEmpty) return [];
    if (dayIndex >= yogaPlan.value!.dailySchedule.length) return [];
    return yogaPlan.value!.dailySchedule[dayIndex].poses;
  }

  /// Optional: total days in the yoga plan
  int get totalDays => yogaPlan.value?.days ?? 0;
}
