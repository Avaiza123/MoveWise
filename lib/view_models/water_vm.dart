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

  /// Load entries (today + cleanup 30 days)
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
    _updateProgress();

    // Save cleaned map back
    await prefs.setString(cacheKey, jsonEncode(decoded));
  }

  /// Persist all entries
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);
    Map<String, dynamic> decoded = {};
    if (data != null) decoded = jsonDecode(data);

    decoded[_todayKey()] = entries.map((e) => e.toJson()).toList();
    await prefs.setString(cacheKey, jsonEncode(decoded));
  }

  /// Add water intake
  void addWater(int amount) {
    entries.add(WaterEntry(amount: amount, timestamp: DateTime.now()));
    _updateProgress();
    _saveEntries();
  }

  /// Undo last entry
  void undoLastEntry() {
    if (entries.isNotEmpty) {
      entries.removeLast();
      _updateProgress();
      _saveEntries();
    }
  }

  /// Set water manually (slider)
  void setWater(int value) {
    final clamped = value.clamp(0, dailyGoal);
    entries.clear();
    if (clamped > 0) {
      entries.add(WaterEntry(amount: clamped, timestamp: DateTime.now()));
    }
    _updateProgress();
    _saveEntries();
  }

  void _updateProgress() {
    totalIntake.value = entries.fold(0, (sum, e) => sum + e.amount);
    progress.value = (totalIntake.value / dailyGoal).clamp(0.0, 1.0);
  }

  /// Archive yesterday and reset today
  Future<void> saveDailyTotal() async {
    await _saveEntries();
    entries.clear();
    totalIntake.value = 0;
    progress.value = 0.0;
    today = DateTime.now();
  }

  /// Last 24h history (includes yesterday if within cutoff)
  Future<List<WaterEntry>> getLast24HourEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);
    Map<String, dynamic> decoded = {};
    if (data != null) decoded = jsonDecode(data);

    List<WaterEntry> history = [];
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));

    decoded.forEach((key, value) {
      (value as List).forEach((e) {
        final entry = WaterEntry.fromJson(e);
        if (entry.timestamp.isAfter(cutoff)) {
          history.add(entry);
        }
      });
    });

    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return history;
  }

  /// Ensure reset on new day
  Future<void> checkNewDay() async {
    final now = DateTime.now();
    if (!_isSameDay(now, today)) {
      await saveDailyTotal();
      today = now;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Load all previous days' entries (excluding today)
  Future<List<WaterEntry>> loadPreviousEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cacheKey);
    if (data == null) return [];

    final Map<String, dynamic> decoded = jsonDecode(data);
    final todayStr = _todayKey();

    List<WaterEntry> history = [];

    decoded.forEach((key, value) {
      if (key != todayStr) {
        history.addAll((value as List).map((e) => WaterEntry.fromJson(e)));
      }
    });

    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return history;
  }

  String _todayKey() => today.toIso8601String().substring(0, 10);
}
