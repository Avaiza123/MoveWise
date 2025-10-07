import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/res/routes/route_name.dart';

import '../../models/exercise_model.dart';
import '../../models/yoga_model.dart';
import '../../view_models/plan_vm.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_appbar.dart';

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late List<dynamic> exercises; // Exercise or YogaPose
  late int planIndex;
  late bool isYoga;

  int currentIndex = 0;
  final PlanVM planVM = Get.find<PlanVM>();
  final box = GetStorage();

  // ✅ Yoga timer state
  Timer? _timer;
  int _remainingTime = 0;
  bool _yogaFinished = false;
  bool _yogaStarted = false; // <-- New state for Start button

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    exercises = args["exercises"];
    planIndex = args["planIndex"];
    isYoga = args["isYoga"];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startYogaTimer(YogaPose pose) {
    setState(() {
      _yogaStarted = true;
      _remainingTime = pose.timeSpentSeconds;
      _yogaFinished = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        setState(() => _yogaFinished = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ex = exercises[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "Exercise ${currentIndex + 1}/${exercises.length}",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Exercise / Yoga Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isYoga && ex is YogaPose
                  ? Image.network(
                ex.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image, size: 150),
              )
                  : (ex is Exercise)
                  ? Image.network(
                ex.animationUrl,
                height: 320,
                width: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported, size: 100),
              )
                  : const Icon(Icons.image_not_supported, size: 100),
            ),
            const SizedBox(height: 24),

            // ✅ Title
            Text(
              isYoga
                  ? (ex as YogaPose).title
                  : (ex as Exercise).title,
              style: GoogleFonts.aboreto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // ✅ Details Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor.withOpacity(0.3), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: isYoga && ex is YogaPose
                  ? Column(
                children: [
                  !_yogaStarted
                      ? ElevatedButton(
                    onPressed: () => _startYogaTimer(ex),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 84, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(800),
                      ),
                    ),
                    child: Text(
                      "Start Timer",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : Column(
                    children: [
                      Text(
                        _yogaFinished
                            ? "Completed!"
                            : "Hold the pose",
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(60),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColorDark,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Text(
                          _yogaFinished
                              ? "👍🏻"
                              : "$_remainingTime",
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  : Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoBox("Sets", "${(ex as Exercise).sets}"),
                      _buildInfoBox("Reps", "${ex.reps}"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Take 45 sec break after every set",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ✅ Done Button
            ElevatedButton(
              onPressed: (isYoga && (!_yogaFinished || !_yogaStarted))
                  ? null
                  : _onDonePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColorDark,
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                currentIndex == exercises.length - 1 ? "Finish Day" : "Next",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ UI helper for sets/reps
  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Done action
  void _onDonePressed() {
    if (currentIndex < exercises.length - 1) {
      // ✅ Go to next exercise
      setState(() {
        currentIndex++;
        _yogaStarted = false; // reset for next yoga pose
      });
    } else {
      // ✅ Mark current plan day done in PlanVM + save cache
      planVM.markCurrentDayDone(planIndex);

      // ✅ Update local streak or completion log
      final key = "streak_day_$planIndex";
      final previousStreak = box.read(key) ?? 0;
      box.write(key, previousStreak + 1);

      // ✅ Navigate back to Dashboard
      Get.until((route) => Get.currentRoute == RouteName.DashboardScreen);

      // ✅ Show confirmation
      Get.snackbar(
        "Great Job! 🎉",
        "Day completed successfully. Keep going!",
        backgroundColor: AppColors.primaryColorDark.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
      Get.toNamed(RouteName.DashboardScreen);
    }
  }

}
