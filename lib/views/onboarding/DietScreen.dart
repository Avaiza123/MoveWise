import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_texts.dart';
import '../../core/constants/app_icons.dart';
import '../../core/utils/app_styles.dart';
import '../../core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final Set<String> selectedRestrictions = {};

  final List<Map<String, dynamic>> dietRestrictions = [
    {'name': AppText.dietVegan, 'icon': AppIcons.vegan},
    {'name': AppText.dietVegetarian, 'icon': AppIcons.vegetarian},
    {'name': AppText.dietGlutenFree, 'icon': AppIcons.glutenFree},
    {'name': AppText.dietDairyFree, 'icon': AppIcons.dairyFree},
    {'name': AppText.dietLowSugar, 'icon': AppIcons.lowSugar},
    {'name': AppText.dietNoRestrictions, 'icon': AppIcons.noRestrictions},
  ];

  void _toggleRestriction(String restriction) {
    setState(() {
      if (restriction == AppText.dietNoRestrictions) {
        if (selectedRestrictions.contains(restriction)) {
          selectedRestrictions.remove(restriction);
        } else {
          selectedRestrictions
            ..clear()
            ..add(restriction);
        }
      } else {
        selectedRestrictions.remove(AppText.dietNoRestrictions);
        selectedRestrictions.contains(restriction)
            ? selectedRestrictions.remove(restriction)
            : selectedRestrictions.add(restriction);
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setStringList(
        'diet_preferences', selectedRestrictions.toList());

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "test_user";
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        "profile": {
          "diet_preferences": selectedRestrictions.toList(),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving diet preferences: $e");
    }
  }

  Future<void> _navigateNext() async {
    if (selectedRestrictions.isNotEmpty) {
      await _savePreferences();
      Get.toNamed(RouteName.DashboardScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppText.dietSelectionError,
            style: AppStyles.snackBarTextStyle,
          ),
          backgroundColor: AppColors.buttonColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSizes.paddingLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
        ),
      );
    }
  }

  Widget _buildRestrictionCard(String name, IconData icon) {
    final isSelected = selectedRestrictions.contains(name);
    final noRestrictionsSelected =
    selectedRestrictions.contains(AppText.dietNoRestrictions);
    final isDisabled =
        noRestrictionsSelected && name != AppText.dietNoRestrictions;

    return IgnorePointer(
      ignoring: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: GestureDetector(
          onTap: () => _toggleRestriction(name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            margin: const EdgeInsets.all(AppSizes.sm),
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(0.25)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: isSelected ? AppColors.white : AppColors.primaryColorDark,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.acme(
                    fontSize: AppSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectDietTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppText.dietQuestion,
              style: GoogleFonts.aboreto(
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSizes.gapMedium),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1, // ✅ squares like goals
                crossAxisSpacing: AppSizes.s4,
                mainAxisSpacing: AppSizes.s4,
                children: dietRestrictions
                    .map((restriction) => _buildRestrictionCard(
                  restriction['name'],
                  restriction['icon'],
                ))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSizes.gapMedium),
            Center(
              child: SizedBox(
                width: 190,
                height: 60,
                child: ElevatedButton(
                  onPressed: _navigateNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppText.continueButton,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.gapLarge),
          ],
        ),
      ),
    );
  }
}
