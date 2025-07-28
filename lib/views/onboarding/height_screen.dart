import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_texts.dart';
import '../../core/utils/app_styles.dart';
import '../../core/res/routes/route_name.dart';

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
      scrollToValue();
    });
  }

  void scrollToValue() {
    final int minValue = selectedUnit == 'cm' ? 100 : 48;
    final double offset = (sliderValue - minValue) * 30;
    if (scrollController.hasClients) {
      scrollController.jumpTo(offset.clamp(0, scrollController.position.maxScrollExtent));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int minValue = selectedUnit == 'cm' ? 100 : 48;
    final int maxValue = selectedUnit == 'cm' ? 220 : 84;

    return Scaffold(
      appBar: AppStyles.customAppBar(AppText.selectYourHeight),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              /// ✅ Card UI
              Container(
                decoration: AppStyles.cardDecoration,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg, vertical: AppSizes.lg),
                child: Column(
                  children: [
                    /// Toggle Buttons
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
                          scrollToValue();
                        });
                      },
                      color: AppColors.white,
                      selectedColor: AppColors.primary,
                      fillColor: AppColors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                          child: Text(AppText.cm),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                          child: Text(AppText.feetInches),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceBetweenItem),

                    /// Value Display
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

                    /// Ruler
                    SizedBox(
                      height: 90,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ListView.builder(
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
                                    scrollToValue();
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 2,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.white,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        selectedUnit == 'cm'
                                            ? "$value"
                                            : "${value ~/ 12}'${value % 12}\"",
                                        style: AppStyles.bodyWhite.copyWith(
                                          fontSize: 12,
                                          color: isSelected
                                              ? AppColors.primary
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
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.sm),

                    /// Slider
                    Slider(
                      value: sliderValue,
                      min: minValue.toDouble(),
                      max: maxValue.toDouble(),
                      divisions: maxValue - minValue,
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
                      label: selectedUnit == 'cm'
                          ? "${sliderValue.round()} cm"
                          : "${sliderValue ~/ 12} ft ${(sliderValue % 12).round()} in",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceBetweenItem),

              /// ✅ NEXT Button
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.bottomSpace),
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final int heightInCm = selectedUnit == 'cm'
                        ? heightCm
                        : ((heightFt * 12 + heightIn) * 2.54).round();

                    await prefs.setBool('onBoarding', false);
                    await prefs.setInt('height_cm', heightInCm);

                    Get.toNamed(
                      RouteName.WeightScreen,
                      arguments: heightInCm.toDouble(),
                    );
                  },
                  style: AppStyles.buttonStyle,
                  child: Text(AppText.next, style: AppStyles.buttonText),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget to show label/value
  Widget _valueBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        children: [
          Text(label, style: AppStyles.bodyWhite),
          const SizedBox(height: AppSizes.xs),
          Text(value, style: AppStyles.headingWhite),
        ],
      ),
    );
  }
}
