import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_model.dart';

class WaterTrackerViewModel extends GetxController {
  final RxList<WaterEntry> entries = <WaterEntry>[].obs; // today's entries
  final RxDouble progress = 0.0.obs;
  final RxInt totalIntake = 0.obs; // today's total
  final int dailyGoal = 3700; // ml
  final String cacheKey = "water_entries_30days";

  DateTime today = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    _loadEntries();
  }

  /// Load today's total from cache
  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);
    Map<String, dynamic> decoded = {};

    if (data != null) decoded = jsonDecode(data);

    // Clean entries older than 30 days
    decoded.removeWhere((key, _) =>
        DateTime.parse(key).isBefore(DateTime.now().subtract(const Duration(days: 30))));

    final todayStr = _todayKey();
    List<WaterEntry> todayEntries = [];
    if (decoded.containsKey(todayStr)) {
      todayEntries = (decoded[todayStr] as List)
          .map((e) => WaterEntry.fromJson(e))
          .toList();
    }

    entries.assignAll(todayEntries);
    totalIntake.value = entries.fold(0, (sum, e) => sum + e.amount);
    progress.value = (totalIntake.value / dailyGoal).clamp(0.0, 1.0);
  }

  /// Add water to today's total
  void addWater(int amount) {
    totalIntake.value += amount;
    progress.value = (totalIntake.value / dailyGoal).clamp(0.0, 1.0);
    entries.add(WaterEntry(amount: amount, timestamp: DateTime.now()));
  }

  /// Undo last addition
  void undoLastEntry() {
    if (entries.isNotEmpty) {
      totalIntake.value -= entries.last.amount;
      entries.removeLast();
      progress.value = (totalIntake.value / dailyGoal).clamp(0.0, 1.0);
    }
  }

  /// Set water value manually (from slider)
  void setWater(int value) {
    totalIntake.value = value.clamp(0, dailyGoal);
    updateProgress();
  }

  void updateProgress() {
    totalIntake.value = entries.fold(0, (sum, e) => sum + e.amount);
    progress.value = (totalIntake.value / dailyGoal).clamp(0.0, 1.0);
  }

  /// Save today's total to cache and reset for new day
  Future<void> saveDailyTotal() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);
    Map<String, dynamic> decoded = {};
    if (data != null) decoded = jsonDecode(data);

    decoded[_todayKey()] = entries.map((e) => e.toJson()).toList();

    await prefs.setString(cacheKey, jsonEncode(decoded));

    // reset for new day
    entries.clear();
    totalIntake.value = 0;
    progress.value = 0.0;
    today = DateTime.now();
  }
  Future<List<WaterEntry>> getLast24HourEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);
    Map<String, dynamic> decoded = {};
    if (data != null) decoded = jsonDecode(data);

    List<WaterEntry> history = [];

    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(hours: 24));

    decoded.forEach((key, value) {
      final date = DateTime.parse(key);
      if (date.isAfter(cutoff)) {
        history.addAll((value as List).map((e) => WaterEntry.fromJson(e)));
      }
    });

    // sort by timestamp descending
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return history;
  }

  /// Returns today's key for caching
  String _todayKey() => today.toIso8601String().substring(0, 10);

  /// Call on app startup to check if date changed
  Future<void> checkNewDay() async {
    final now = DateTime.now();
    if (!_isSameDay(now, today)) {
      await saveDailyTotal();
      today = now;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Load previous days' entries for history list
  Future<List<WaterEntry>> loadPreviousEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);
    if (data == null) return [];

    final Map<String, dynamic> decoded = jsonDecode(data);
    final todayStr = _todayKey();

    List<WaterEntry> history = [];

    decoded.forEach((key, value) {
      if (key != todayStr) {
        final dayEntries = (value as List)
            .map((e) => WaterEntry.fromJson(e))
            .toList();
        history.addAll(dayEntries);
      }
    });

    history.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // latest first
    return history;
  }
}
