import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/utils/app_styles.dart';
import '../../core/res/routes/route_name.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final Set<String> selectedRestrictions = {};

  final List<Map<String, dynamic>> dietRestrictions = [
    {'name': AppText.dietVegan, 'icon': Icons.spa},
    {'name': AppText.dietVegetarian, 'icon': Icons.eco},
    {'name': AppText.dietGlutenFree, 'icon': Icons.no_food},
    {'name': AppText.dietDairyFree, 'icon': Icons.icecream},
    {'name': AppText.dietLowSugar, 'icon': Icons.local_cafe},
    {'name': AppText.dietNoRestrictions, 'icon': Icons.not_interested},
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

  Future<void> _navigateNext() async {
    if (selectedRestrictions.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
      await prefs.setStringList('diet_preferences', selectedRestrictions.toList());

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
    final bool noRestrictionsSelected = selectedRestrictions.contains(AppText.dietNoRestrictions);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppSizes.appBarHeight),
        child: AppStyles.customAppBar(AppText.selectDietTitle),
      ),
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

            Expanded(
              child: ListView.builder(
                itemCount: dietRestrictions.length,
                itemBuilder: (context, index) {
                  final restriction = dietRestrictions[index];
                  final String name = restriction['name'];
                  final IconData icon = restriction['icon'];
                  final bool isSelected = selectedRestrictions.contains(name);
                  final bool isDisabled = noRestrictionsSelected && name != AppText.dietNoRestrictions;

                  return IgnorePointer(
                    ignoring: isDisabled,
                    child: Opacity(
                      opacity: isDisabled ? 0.4 : 1.0,
                      child: GestureDetector(
                        onTap: () => _toggleRestriction(name),
                        child: Card(
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(0.3)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: AppSizes.gapSmall),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.paddingLarge,
                              horizontal: AppSizes.paddingMediumLarge,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.primaryColor,
                                  size: AppSizes.iconLg,
                                ),
                                const SizedBox(width: AppSizes.gapMedium),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: AppSizes.fontSizeLg,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSizes.gapMedium),

            Center(
              child: ElevatedButton(
                onPressed: _navigateNext,
                style: AppStyles.elevatedButtonStyle,
                child: Text(AppText.continueButton, style: AppStyles.buttonText),
              ),
            ),
            const SizedBox(height: AppSizes.gapLarge),
          ],
        ),
      ),
    );
  }
}
