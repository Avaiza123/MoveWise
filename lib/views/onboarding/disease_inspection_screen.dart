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

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  final Set<String> selectedDiseases = {};

  final List<Map<String, dynamic>> diseases = [
    {'name': AppText.diseaseDiabetes, 'icon': AppIcons.diabetes},
    {'name': AppText.diseaseBP, 'icon': AppIcons.bp},
    {'name': AppText.diseaseKneePain, 'icon': AppIcons.kneePain},
    {'name': AppText.diseaseAnklePain, 'icon': AppIcons.anklePain},
    {'name': AppText.diseaseBackPain, 'icon': AppIcons.back},
    {'name': AppText.diseaseMigraine, 'icon': AppIcons.migraine},
    {'name': AppText.diseaseNone, 'icon': AppIcons.none},
  ];

  void _toggleDisease(String disease) {
    setState(() {
      if (selectedDiseases.contains(disease)) {
        selectedDiseases.remove(disease);
      } else {
        if (disease == AppText.diseaseNone) {
          selectedDiseases
            ..clear()
            ..add(disease);
        } else {
          selectedDiseases.remove(AppText.diseaseNone);
          selectedDiseases.add(disease);
        }
      }
    });
  }

  Future<void> _navigateNext() async {
    if (selectedDiseases.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', false);
      await prefs.setStringList('selected_diseases', selectedDiseases.toList());

      Get.toNamed(RouteName.DietScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppText.diseaseSelectionError,
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
    final bool isNoIssueSelected = selectedDiseases.contains(AppText.diseaseNone);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectYourDiseaseTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: AppSizes.paddingLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.diseaseQuestion, style: AppStyles.screenTitle),
            const SizedBox(height: AppSizes.gapLarge),

            /// Diseases List
            Expanded(
              child: ListView.builder(
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  final disease = diseases[index];
                  final String name = disease['name'];
                  final IconData icon = disease['icon'];
                  final bool isSelected = selectedDiseases.contains(name);
                  final bool isDisabled = isNoIssueSelected && name != AppText.diseaseNone;

                  return IgnorePointer(
                    ignoring: isDisabled,
                    child: Opacity(
                      opacity: isDisabled ? 0.4 : 1.0,
                      child: GestureDetector(
                        onTap: () => _toggleDisease(name),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: AppSizes.gapSmall),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.paddingMediumLarge,
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
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? AppColors.white
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
