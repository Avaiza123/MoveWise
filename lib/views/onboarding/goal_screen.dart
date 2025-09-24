import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> selectedGoals = {};
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (goal == "Nothing Special") {
        if (selectedGoals.contains("Nothing Special")) {
          // ✅ Deselect "Nothing Special" if tapped again
          selectedGoals.remove("Nothing Special");
        } else {
          // ✅ Select "Nothing Special" and clear others
          selectedGoals.clear();
          selectedGoals.add("Nothing Special");
        }
      } else {
        // ✅ If "Nothing Special" was selected, clear it
        if (selectedGoals.contains("Nothing Special")) {
          selectedGoals.clear();
        }

        // ✅ Toggle normal goals
        if (selectedGoals.contains(goal)) {
          selectedGoals.remove(goal);
        } else {
          selectedGoals.add(goal);
        }
      }
    });
  }


  Future<void> _handleNavigation() async {
    if (selectedGoals.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', false);
      await prefs.setStringList('selected_goals', selectedGoals.toList());

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          {
            'profile': {'goals': selectedGoals.toList()},
            'timestamp': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
        Get.toNamed(RouteName.HeightScreen);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not logged in. Please sign in."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.buttonColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          ),
          content: Text(
            AppText.goalSelectionError,
            style: AppStyles.snackBarTextStyle,
          ),
        ),
      );
    }
  }

  Widget _buildGoalCard(String goal, IconData icon) {
    final isSelected = selectedGoals.contains(goal);
    final isNothingSpecialSelected = selectedGoals.contains("Nothing Special");

    // ✅ Disable and grey out other goals if "Nothing Special" is active
    final isDisabled = isNothingSpecialSelected && goal != "Nothing Special";

    return GestureDetector(
      onTap: isDisabled ? null : () => _toggleGoal(goal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade200 // 🔹 greyed out if disabled
              : isSelected
              ? AppColors.primaryColor
              : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.shade400 // 🔹 grey border when disabled
                : isSelected
                ? AppColors.primaryColor
                : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            if (!isDisabled)
              BoxShadow(
                color: isSelected
                    ? AppColors.primaryColor.withOpacity(0.35)
                    : Colors.grey.withOpacity(0.15),
                blurRadius: isSelected ? 10 : 6,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
              color: isDisabled
                  ? Colors.grey.shade400 // 🔹 greyed out icon
                  : isSelected
                  ? Colors.white
                  : Colors.grey[700],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              goal,
              textAlign: TextAlign.center,
              style: GoogleFonts.acme(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? Colors.grey.shade500 // 🔹 greyed out text
                    : isSelected
                    ? Colors.white
                    : AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.65;

    final Map<String, IconData> goalIcons = {
      "Lose Weight": Icons.fitness_center,
      "Build Muscle": Icons.sports_martial_arts,
      "Increase Flexibility": Icons.accessibility_new,
      "Improve Posture": Icons.directions_run,
      "Stay Fit": Icons.health_and_safety,
      "Nothing Special": Icons.sentiment_neutral,
    };

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectYourGoalTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md, vertical: AppSizes.md), // less padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppText.fitnessQuestion,
              style: GoogleFonts.aboreto(
                  fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSizes.sm),

            // ✅ Grid with tighter spacing and bigger squares
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.1, // ✅ squares like goals
                crossAxisSpacing: AppSizes.lg,
                mainAxisSpacing: AppSizes.lg, // 🔹 reduced vertical gap
                children: goalIcons.entries.map((entry) {
                  return _buildGoalCard(entry.key, entry.value);
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSizes.s4),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: fieldWidth * 0.7, // button slightly bigger
                height: 58,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _handleNavigation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    AppText.continueButton,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}
