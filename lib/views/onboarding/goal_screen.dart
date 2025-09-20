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

class _GoalScreenState extends State<GoalScreen> with SingleTickerProviderStateMixin {
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
      selectedGoals.contains(goal)
          ? selectedGoals.remove(goal)
          : selectedGoals.add(goal);
      _animationController.forward(from: 0);
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

    return GestureDetector(
      onTap: () => _toggleGoal(goal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.md,
          horizontal: AppSizes.mdLg,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: isSelected
              ? const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : AppColors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.shade200,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                goal,
                style: GoogleFonts.acme(
                  fontSize: AppSizes.fontSizeLg,
                  color: isSelected ? AppColors.white : AppColors.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.white : Colors.grey[600],
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.85;

    // Map goals to icons
    final Map<String, IconData> goalIcons = {
      "Lose Weight": Icons.fitness_center,
      "Build Muscle": Icons.sports_martial_arts,
      "Increase Flexibility": Icons.accessibility_new,
      "Improve Posture": Icons.directions_run,
      "Stay Fit": Icons.health_and_safety,
    };

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectYourGoalTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppText.fitnessQuestion,
              style: GoogleFonts.aboreto(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSizes.lg),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AppText.fitnessGoals.length,
                itemBuilder: (context, index) {
                  final goal = AppText.fitnessGoals[index];
                  final icon = goalIcons[goal] ?? Icons.star;
                  return _buildGoalCard(goal, icon);
                },
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: fieldWidth * 0.6,
                height: 56,
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
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
