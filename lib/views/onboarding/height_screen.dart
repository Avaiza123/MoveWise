import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_texts.dart';
import '../../core/utils/app_styles.dart';
import '../../core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  String selectedUnit = 'cm';
  int heightCm = 160;
  int heightFt = 5;
  int heightIn = 4;
  double sliderValue = 160;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToValue();
    });
  }

  void _scrollToValue() {
    final int minValue = selectedUnit == 'cm' ? 100 : 48;
    final double offset = (sliderValue - minValue) * 30;
    if (scrollController.hasClients) {
      scrollController.jumpTo(
        offset.clamp(0, scrollController.position.maxScrollExtent),
      );
    }
  }

  Future<void> _saveHeightAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert height to cm if unit is ft/in
    final int heightInCm = selectedUnit == 'cm'
        ? heightCm
        : ((heightFt * 12 + heightIn) * 2.54).round();

    // Save height and onboarding flag in cache
    await prefs.setInt('height_cm', heightInCm);
    await prefs.setBool('onboarding_done', true);

    // Navigate to Weight Screen
    Get.toNamed(RouteName.WeightScreen, arguments: heightInCm.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final int minValue = selectedUnit == 'cm' ? 100 : 48;
    final int maxValue = selectedUnit == 'cm' ? 220 : 84;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectYourHeight),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              // Height Card
              Container(
                decoration: AppStyles.cardDecoration.copyWith(
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.5),
                      blurRadius: 19,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.lg,
                ),
                child: Column(
                  children: [
                    // Toggle Units
                    ToggleButtons(
                      isSelected: [
                        selectedUnit == 'cm',
                        selectedUnit == 'ft/in',
                      ],
                      onPressed: (index) {
                        setState(() {
                          selectedUnit = index == 0 ? 'cm' : 'ft/in';
                          sliderValue = selectedUnit == 'cm'
                              ? heightCm.toDouble()
                              : (heightFt * 12 + heightIn.toDouble());
                          _scrollToValue();
                        });
                      },
                      color: AppColors.white.withOpacity(0.7),
                      selectedColor: AppColors.primaryColor,
                      fillColor: AppColors.white,
                      borderColor: Colors.white70,
                      selectedBorderColor: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.lg, vertical: AppSizes.sm),
                          child: Text(AppText.cm),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.lg, vertical: AppSizes.sm),
                          child: Text(AppText.feetInches),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceBetweenItem),

                    // Value Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: selectedUnit == 'cm'
                          ? [_valueBox(AppText.height, "$heightCm cm")]
                          : [
                        _valueBox(AppText.feet, "$heightFt ft"),
                        _valueBox(AppText.inches, "$heightIn in"),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceBetweenItem),

                    // Ruler
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: maxValue - minValue + 1,
                        itemBuilder: (context, index) {
                          final value = minValue + index;
                          final isSelected = selectedUnit == 'cm'
                              ? value == heightCm
                              : value == (heightFt * 12 + heightIn);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                sliderValue = value.toDouble();
                                if (selectedUnit == 'cm') {
                                  heightCm = value;
                                } else {
                                  heightFt = value ~/ 12;
                                  heightIn = value % 12;
                                }
                                _scrollToValue();
                              });
                            },
                            child: Container(
                              width: 30,
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: isSelected ? 28 : 18,
                                    width: 2,
                                    color: isSelected
                                        ? AppColors.accentColor
                                        : AppColors.white,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedUnit == 'cm'
                                        ? "$value"
                                        : "${value ~/ 12}'${value % 12}\"",
                                    style: AppStyles.bodyWhite.copyWith(
                                      fontSize: isSelected ? 13 : 11,
                                      color: isSelected
                                          ? AppColors.accentColor
                                          : AppColors.white,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: AppSizes.sm),

                    // Slider
                    Slider(
                      value: sliderValue,
                      min: minValue.toDouble(),
                      max: maxValue.toDouble(),
                      divisions: maxValue - minValue,
                      activeColor: AppColors.accentColor,
                      inactiveColor: Colors.white30,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                          if (selectedUnit == 'cm') {
                            heightCm = value.round();
                          } else {
                            heightFt = value ~/ 12;
                            heightIn = (value % 12).round();
                          }
                        });
                        scrollController.animateTo(
                          (value - minValue) * 30,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceBetweenItem * 1.5),

              // Next Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: ElevatedButton(
                  onPressed: _saveHeightAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    ),
                  ),
                  child: Text(
                    AppText.next,
                    style: AppStyles.buttonText.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Value display widget
  Widget _valueBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        children: [
          Text(label, style: AppStyles.bodyWhite),
          const SizedBox(height: AppSizes.xs),
          Text(
            value,
            style: AppStyles.headingWhite.copyWith(color: AppColors.accentColor),
          ),
        ],
      ),
    );
  }
}
