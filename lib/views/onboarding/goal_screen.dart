import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart'; // ✅ Custom gradient AppBar

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final Set<String> selectedGoals = {};

  void _toggleGoal(String goal) {
    setState(() {
      selectedGoals.contains(goal)
          ? selectedGoals.remove(goal)
          : selectedGoals.add(goal);
    });
  }

  Future<void> _handleNavigation() async {
    if (selectedGoals.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', false);
      await prefs.setStringList('selected_goals', selectedGoals.toList());

      Get.toNamed(RouteName.HeightScreen);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ✅ Use Custom Gradient AppBar
      appBar: const CustomAppBar(
        title: AppText.selectYourGoalTitle,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.fitnessQuestion, style: AppStyles.screenTitle),
            const SizedBox(height: AppSizes.lg),

            /// Fitness Goal List
            Expanded(
              child: ListView.builder(
                itemCount: AppText.fitnessGoals.length,
                itemBuilder: (context, index) {
                  final goal = AppText.fitnessGoals[index];
                  final isSelected = selectedGoals.contains(goal);

                  return GestureDetector(
                    onTap: () => _toggleGoal(goal),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(
                        vertical: AppSizes.sm,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: isSelected ? null : AppColors.white,
                        borderRadius:
                        BorderRadius.circular(AppSizes.cardRadius),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade300,
                          width: 2,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.md,
                          horizontal: AppSizes.mdLg,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? AppColors.white
                                  : Colors.grey[600],
                              size: 26,
                            ),
                            const SizedBox(width: AppSizes.md),
                            Expanded(
                              child: Text(
                                goal,
                                style: TextStyle(
                                  fontSize: AppSizes.fontSizeLg,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSizes.md),

            /// ✅ Gradient Continue Button (same as GenderScreen)
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: ElevatedButton(
                  onPressed: _handleNavigation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    ),
                  ),
                  child: Text(
                    AppText.continueButton,
                    style: AppStyles.buttonText.copyWith(color: Colors.white),
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
