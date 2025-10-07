import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import '../../view_models/plan_vm.dart';
import '../../view_models/yoga_vm.dart';
import '../../models/exercise_model.dart';
import '../../models/yoga_model.dart';
import '../../core/constants/app_colors.dart';

class PlanScreen extends StatefulWidget {
  final int planIndex;

  const PlanScreen({super.key, required this.planIndex});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final PlanVM planVM = Get.find<PlanVM>();
  final YogaVM yogaVM = Get.put(YogaVM(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (planVM.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (planVM.plans.isEmpty) {
          return const Center(child: Text("No plans available"));
        }

        final plan = planVM.plans[widget.planIndex];
        final dayIndex = planVM.currentDayIndices[widget.planIndex];
        final dayNumber = dayIndex + 1;

        // 🔹 Determine if it's a rest day
        bool isRestDay = false;
        List<dynamic> exercises = [];

        if (plan.isYoga) {
          if (yogaVM.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (yogaVM.yogaPlan.value == null) {
            return const Center(child: Text("Yoga plan not available"));
          }
          exercises = yogaVM.yogaPlan.value!.dailySchedule[dayIndex].poses;
        } else {
          final currentDay = plan.dailySchedule[dayIndex];
          isRestDay = currentDay.isRest;
          if (!isRestDay) {
            exercises = currentDay.exercises;
          }
        }

        return CustomScrollView(
          slivers: [
            // 🔹 Header
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColorDark, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            plan.name.toUpperCase(),
                            style: GoogleFonts.merriweatherSans(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "DAY $dayNumber",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isRestDay
                          ? "Take a well-deserved break today 😌"
                          : plan.isYoga
                          ? "Follow the yoga poses below. Hold each pose as instructed."
                          : "Step-by-step workout to burn calories effectively!",
                      style:
                      GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _infoCard("Level", "Intermediate"),
                        _infoCard("Duration", isRestDay ? "Rest" : "10 mins"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Rest Day View
            if (isRestDay)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        const Text("🛌", style: TextStyle(fontSize: 80)),
                        const SizedBox(height: 16),
                        Text(
                          "Rest Day!",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Relax, recover, and get ready for tomorrow!",
                          style: GoogleFonts.poppins(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        width: 180,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColorDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(44),
                            ),
                          ),
                          onPressed: () {
                            // ✅ Mark current day completed
                            planVM.markCurrentDayDone(widget.planIndex);

                            // ✅ Feedback
                            Get.snackbar(
                              "Rest Day Completed 🎉",
                              "Great! You took your well-deserved break.",
                              backgroundColor:
                              AppColors.primaryColorDark.withOpacity(0.9),
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(12),
                              borderRadius: 10,
                              duration: const Duration(seconds: 2),
                            );

                            // ✅ Go to Dashboard
                            Get.offAllNamed(RouteName.DashboardScreen);
                          },
                          child: Text(
                            "NEXT DAY",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
            // 🔹 Exercises List
              SliverPadding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final ex = exercises[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _exerciseTile(ex, isYoga: plan.isYoga),
                      );
                    },
                    childCount: exercises.length,
                  ),
                ),
              ),

            // 🔹 Button for non-rest days
            if (!isRestDay)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: SizedBox(
                      width: 180,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColorDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(44),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            RouteName.ExerciseDetailScreen,
                            arguments: {
                              "exercises": exercises,
                              "planIndex": widget.planIndex,
                              "isYoga": plan.isYoga,
                            },
                          );
                        },
                        child: Text(
                          "START",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // 🔹 Info Card
  Widget _infoCard(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ],
    );
  }

  // 🔹 Exercise Tile
  Widget _exerciseTile(dynamic ex, {bool isYoga = false}) {
    String exerciseName = "Unknown Exercise";
    String subtitleText = "";

    if (isYoga && ex is YogaPose) {
      exerciseName = ex.title.isNotEmpty ? ex.title : exerciseName;
      subtitleText = "Hold for ${ex.timeSpentSeconds}s";
    } else if (ex is Exercise) {
      exerciseName = ex.title.isNotEmpty ? ex.title : exerciseName;
      subtitleText = "Sets: ${ex.sets} • Reps: ${ex.reps}";
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: isYoga && ex is YogaPose
              ? Image.network(
            ex.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported, size: 40),
          )
              : ex is Exercise
              ? (ex.animationUrl.startsWith("http")
              ? Image.network(
            ex.animationUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported, size: 40),
          )
              : Image.asset(
            ex.animationUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ))
              : const SizedBox(width: 60, height: 60),
        ),
        title: Text(exerciseName,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitleText,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
        trailing: isYoga
            ? const Icon(Icons.self_improvement, color: Colors.orange)
            : const Icon(Icons.play_circle_fill,
            size: 28, color: Colors.orange),
      ),
    );
  }
}
