import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../models/exercise_model.dart';
import '../../view_models/exercise_vm.dart';
import '../../widgets/custom_appbar.dart';
import 'exercise_detail_screen.dart';

class ExercisePlanScreen extends StatelessWidget {
  final String title;
  final String fileName; // 🔹 which JSON file to load (or BMI category)

  const ExercisePlanScreen({
    super.key,
    required this.title,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(ExerciseViewModel());

    // load exercises for this plan
  //  vm.loadExercisesFromJson(fileName);

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Obx(() {
        if (vm.exercises.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.exercises.length,
          itemBuilder: (context, index) {
            final exercise = vm.exercises[index];
            return InkWell(
              onTap: () => Get.to(() => ExerciseDetailScreen(exercise: exercise)),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      exercise.animationUrl, // full Cloudinary URL from JSON
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 40); // fallback icon
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                    ),
                  ),

                  title: Text(
                    exercise.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  subtitle: Text(
                    "Sets: ${exercise.sets} • Reps: ${exercise.reps}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.brown),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
