import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/core/res/routes/route_name.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? selectedGender;

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  Future<void> _navigateNext() async {
    if (selectedGender != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', false);
      await prefs.setString('selected_gender', selectedGender!);

      Get.toNamed(RouteName.GoalScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  AppText.genderSelectionError,
                  style: AppStyles.snackBarTextStyle,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.buttonColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          ),
          elevation: 8,
          margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.defaultSpace, vertical: AppSizes.sm),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildGenderCard({
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedGender == label;

    return GestureDetector(
      onTap: () => _selectGender(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.md,
          horizontal: AppSizes.mdLg,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconLg,
              color: isSelected
                  ? AppColors.primaryColorDark
                  : Colors.grey[700],
            ),
            const SizedBox(width: AppSizes.md),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.primaryColorDark
                    : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSizes.appBarHeight),
        child: AppStyles.customAppBar(AppText.selectYourGenderTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.genderQuestion, style: AppStyles.screenTitle),
            const SizedBox(height: AppSizes.md),
            Text(
              AppText.genderSubText,
              style: AppStyles.label,
            ),
            const SizedBox(height: AppSizes.xl),
            _buildGenderCard(label: AppText.genderMale, icon: Icons.male),
            _buildGenderCard(label: AppText.genderFemale, icon: Icons.female),
            _buildGenderCard(
              label: AppText.genderPreferNotToSay,
              icon: Icons.help_outline_rounded,
            ),
            const SizedBox(height: AppSizes.lg),
            Center(
              child: ElevatedButton(
                onPressed: _navigateNext,
                style: AppStyles.elevatedButtonStyle,
                child: Text(AppText.continueButton,
                    style: AppStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
