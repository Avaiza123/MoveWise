import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Toggle selection logic
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

  /// Save onboarding done + diet preferences in cache
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setStringList(
        'diet_preferences', selectedRestrictions.toList());
  }

  /// Navigate to SignupScreen after saving
  Future<void> _navigateNext() async {
    if (selectedRestrictions.isNotEmpty) {
      await _savePreferences();
      Get.toNamed(RouteName.SignupScreen);
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

  @override
  Widget build(BuildContext context) {
    final bool noRestrictionsSelected =
    selectedRestrictions.contains(AppText.dietNoRestrictions);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectDietTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: AppSizes.paddingLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.dietQuestion, style: AppStyles.screenTitle),
            const SizedBox(height: AppSizes.gapLarge),

            /// Diet Restrictions List
            Expanded(
              child: ListView.builder(
                itemCount: dietRestrictions.length,
                itemBuilder: (context, index) {
                  final restriction = dietRestrictions[index];
                  final String name = restriction['name'];
                  final IconData icon = restriction['icon'];
                  final bool isSelected = selectedRestrictions.contains(name);
                  final bool isDisabled =
                      noRestrictionsSelected && name != AppText.dietNoRestrictions;

                  return IgnorePointer(
                    ignoring: isDisabled,
                    child: Opacity(
                      opacity: isDisabled ? 0.4 : 1.0,
                      child: GestureDetector(
                        onTap: () => _toggleRestriction(name),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: AppSizes.gapSmall),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.paddingLarge,
                            horizontal: AppSizes.paddingMediumLarge,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
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
                            color: isSelected ? null : AppColors.cardBackground,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primaryColorDark,
                                size: AppSizes.iconLg,
                              ),
                              const SizedBox(width: AppSizes.gapMedium),
                              Expanded(
                                child: Text(
                                  name,
                                  style: AppStyles.heading.copyWith(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.primaryColorDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppSizes.fontSizeLg,
                                  ),
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? AppIcons.checkCircle
                                    : AppIcons.radioUnchecked,
                                color: isSelected
                                    ? AppColors.white
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSizes.gapMedium),

            /// Continue Button
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: ElevatedButton(
                  onPressed: _navigateNext,
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

            const SizedBox(height: AppSizes.gapLarge),
          ],
        ),
      ),
    );
  }
}
