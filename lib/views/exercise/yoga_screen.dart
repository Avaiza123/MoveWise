import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/exercise_model.dart';
import '../../models/yoga_model.dart';
import '../../view_models/plan_vm.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_appbar.dart';

class YogaScreen extends StatefulWidget {
  const YogaScreen({super.key});

  @override
  State<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  late List<Pose> poses;
  late int planIndex;

  int currentIndex = -1; // ✅ -1 means before starting
  final PlanVM planVM = Get.find<PlanVM>();
  final box = GetStorage();

  Timer? _timer;
  int _remainingTime = 0;
  bool _poseFinished = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    poses = args["poses"]; // ✅ Pass from previous screen
    planIndex = args["planIndex"];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPoseTimer(Pose pose) {
    _remainingTime = pose.timeSpentSeconds;
    _poseFinished = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        setState(() => _poseFinished = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "Yoga Session"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: currentIndex == -1
            ? _buildStartScreen()
            : _buildPoseScreen(poses[currentIndex]),
      ),
    );
  }

  // 🔹 Before starting Yoga
  Widget _buildStartScreen() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            currentIndex = 0;
            _startPoseTimer(poses[0]);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColorDark,
          minimumSize: const Size(220, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          "Start Yoga",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 🔹 Yoga pose detail screen
  Widget _buildPoseScreen(Pose pose) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ✅ Pose Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            pose.imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.image, size: 150),
          ),
        ),
        const SizedBox(height: 24),

        // ✅ Pose Title
        Text(
          pose.title,
          style: GoogleFonts.merriweatherSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // ✅ Timer Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              Text(
                _poseFinished ? "Completed!" : "Hold Pose",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                _poseFinished
                    ? "✅ Done"
                    : "$_remainingTime seconds left",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColorDark,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // ✅ Next / Finish Button
        ElevatedButton(
          onPressed: !_poseFinished ? null : _onNextPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColorDark,
            minimumSize: const Size.fromHeight(55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            currentIndex == poses.length - 1 ? "Finish Yoga" : "Next Pose",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Next pose or finish
  void _onNextPressed() {
    if (currentIndex < poses.length - 1) {
      setState(() {
        currentIndex++;
        _startPoseTimer(poses[currentIndex]);
      });
    } else {
      // ✅ Finish Yoga Session
      planVM.markCurrentDayDone(planIndex);

      final key = "streak_day_$planIndex";
      final previousStreak = box.read(key) ?? 0;
      box.write(key, previousStreak + 1);

      Get.back();
      Get.snackbar(
        "Namaste 🙏",
        "Yoga session completed! Streak updated 🎉",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }
}
