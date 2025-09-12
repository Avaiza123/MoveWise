import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_model.dart';

class WaterTrackerViewModel extends GetxController {
  final RxList<WaterEntry> entries = <WaterEntry>[].obs;
  final int dailyGoal = 3500; // ml
  final String cacheKey = "water_entries";

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);

    if (data != null) {
      List decoded = jsonDecode(data);
      entries.assignAll(decoded.map((e) => WaterEntry.fromJson(e)).toList());

      // Reset if not today
      if (entries.isNotEmpty &&
          entries.first.timestamp.day != DateTime.now().day) {
        clearEntries();
      }
    }
  }

  Future<void> addEntry(String type, int amount) async {
    final entry = WaterEntry(
      type: type,
      amount: amount,
      timestamp: DateTime.now(),
    );
    entries.add(entry);
    await saveEntries();
  }

  Future<void> saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(cacheKey, encoded);
  }

  Future<void> clearEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cacheKey);
    entries.clear();
  }

  /// ✅ Delete entry by index
  Future<void> deleteEntry(int index) async {
    if (index >= 0 && index < entries.length) {
      entries.removeAt(index);
      await saveEntries();
    }
  }

  int get totalIntake => entries.fold(0, (sum, e) => sum + e.amount);
  double get progress => totalIntake / dailyGoal;
}
