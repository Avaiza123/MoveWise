import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../models/exercise_model.dart';
import '../../widgets/custom_appbar.dart';
import 'exercise_detail_screen.dart';

class ExercisePlanScreen extends StatelessWidget {
  final String title;
  final List<Exercise> exercises;

  const ExercisePlanScreen({
    super.key,
    required this.title,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
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
                  child: Image.asset(
                    exercise.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  exercise.title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.brown),
              ),
            ),
          );
        },
      ),
    );
  }
}
