import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import '../../view_models/plan_vm.dart';
import '../../view_models/yoga_vm.dart';
import '../../models/exercise_model.dart';
import '../../models/yoga_model.dart';
import '../../widgets/custom_appbar.dart';
import '../../core/constants/app_colors.dart';

class PlanScreen extends StatefulWidget {
  final int planIndex; // index in vm.plans

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Obx(() {
          if (planVM.plans.isEmpty) return const CustomAppBar(title: "Plan");
          return CustomAppBar(title: planVM.plans[widget.planIndex].name);
        }),
      ),
      body: Obx(() {
        if (planVM.loading.value || planVM.plans.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final plan = planVM.plans[widget.planIndex];
        final dayIndex = planVM.currentDayIndices[widget.planIndex];
        final dayNumber = dayIndex + 1;

        // Exercises for display
        List<dynamic> exercises = [];

        if (plan.isYoga) {
          if (yogaVM.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (yogaVM.yogaPlan.value == null) {
            return Center(child: Text("Yoga plan not available"));
          }

          // Convert YogaPose → Exercise dynamically for uniform display
          exercises = yogaVM.yogaPlan.value!.dailySchedule[dayIndex].poses;
        } else {
          exercises = planVM.exercisesForCurrentDay(widget.planIndex);
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                plan.isYoga ? Icons.self_improvement : Icons.fitness_center,
                size: 72,
                color: AppColors.primaryColorDark,
              ),
              const SizedBox(height: 12),
              Text(
                "${plan.name} - Day $dayNumber",
                style: GoogleFonts.merriweatherSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                plan.isYoga
                    ? "Follow the yoga poses below. Hold each pose as instructed."
                    : "Follow the exercises below. Take 45 sec break after each set.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: exercises.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final ex = exercises[index];
                    return _exerciseTile(ex, isYoga: plan.isYoga);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (dayIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => planVM.currentDayIndices[widget.planIndex]--,
                        child: Text("Previous Day", style: GoogleFonts.poppins()),
                      ),
                    ),
                  if (dayIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        planVM.markCurrentDayDone(widget.planIndex);
                        Get.snackbar(
                          "Great!",
                          "Day $dayNumber completed",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: AppColors.primaryColorDark,
                      ),
                      child: Text(
                        dayIndex == plan.dailySchedule.length - 1 ? "Finish" : "Next Day",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Handles both Exercise and YogaPose tiles
  Widget _exerciseTile(dynamic ex, {bool isYoga = false}) {
    if (isYoga && ex is YogaPose) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              ex.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
            ),
          ),
          title: Text(ex.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          subtitle: Text(
            "Hold for ${ex.timeSpentSeconds} seconds",
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          trailing: const Icon(Icons.self_improvement),
          onTap: () => Get.toNamed(RouteName.ExercisePlanScreen, arguments: ex),
        ),
      );
    } else if (ex is Exercise) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ex.animationUrl.startsWith("http")
                ? Image.network(
              ex.animationUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
            )
                : Image.asset(ex.animationUrl, width: 56, height: 56, fit: BoxFit.cover),
          ),
          title: Text(ex.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          subtitle: Text(
            "Sets: ${ex.sets} • Reps: ${ex.reps}\nTake 45 sec break after every set.",
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          trailing: const Icon(Icons.play_circle_fill),
          onTap: () => Get.toNamed(RouteName.ExercisePlanScreen, arguments: ex),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
