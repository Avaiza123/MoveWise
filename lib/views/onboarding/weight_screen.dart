import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/core/res/routes/route_name.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  String selectedUnit = 'kg';
  double weight = 0;
  double? bmi;

  void _navigateToDisease() {
    Get.toNamed(RouteName.DiseaseScreen);
  }

  Future<void> _calculateBMI(double heightCm) async {
    double weightKg = selectedUnit == 'kg' ? weight : (weight * 0.453592);
    double heightM = heightCm / 100;
    setState(() {
      bmi = weightKg / pow(heightM, 2);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bmi', bmi!);
    await prefs.setBool('onboarding_done', false);
  }

  @override
  Widget build(BuildContext context) {
    final double heightCm = Get.arguments as double;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppStyles.customAppBar(AppText.selectWeight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Toggle for KG / LB
              ToggleButtons(
                isSelected: [selectedUnit == 'kg', selectedUnit == 'lb'],
                onPressed: (index) {
                  setState(() {
                    selectedUnit = index == 0 ? 'kg' : 'lb';
                  });
                },
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: AppColors.primaryColor,
                textStyle: AppStyles.toggleText,
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('KG')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('LB')),
                ],
              ),
              const SizedBox(height: AppSizes.spaceBetweenItem),
              Text(
                '${weight.round()} $selectedUnit',
                style: AppStyles.value,
              ),
              const SizedBox(height: AppSizes.spaceBetweenItem),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 500,
                  itemBuilder: (context, index) {
                    double value = index.toDouble();
                    final isSelected = weight.round() == value.round();
                    return GestureDetector(
                      onTap: () => setState(() => weight = value),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          value.round().toString(),
                          style: textTheme.bodySmall?.copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.spaceBetweenItem),
              ElevatedButton(
                onPressed: () => _calculateBMI(heightCm),
                style: AppStyles.elevatedButtonStyle,
                child: Text(AppText.calculateBMI, style: AppStyles.buttonText),
              ),
              const SizedBox(height: AppSizes.defaultSpace),
              if (bmi != null) ...[
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 10,
                      maximum: 50,
                      ranges: <GaugeRange>[
                        GaugeRange(startValue: 10, endValue: 16, color: Colors.red.shade900),
                        GaugeRange(startValue: 16, endValue: 17, color: Colors.red),
                        GaugeRange(startValue: 17, endValue: 18.5, color: Colors.orange),
                        GaugeRange(startValue: 18.5, endValue: 25, color: Colors.teal),
                        GaugeRange(startValue: 25, endValue: 30, color: Colors.yellow),
                        GaugeRange(startValue: 30, endValue: 35, color: Colors.orangeAccent),
                        GaugeRange(startValue: 35, endValue: 40, color: Colors.deepOrange),
                        GaugeRange(startValue: 40, endValue: 50, color: Colors.redAccent),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(value: bmi!),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            'BMI: ${bmi!.toStringAsFixed(1)}',
                            style: AppStyles.label,
                          ),
                          angle: 90,
                          positionFactor: 0.8,
                        )
                      ],
                    )
                  ],
                ),

                const SizedBox(height: AppSizes.defaultSpace),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.cardPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    gradient: LinearGradient(
                      colors: _bmiGradientColors(bmi!),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(_bmiIcon(bmi!), size: 40, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        _bmiCategory(bmi!),
                        style: AppStyles.screenTitle.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _bmiSuggestion(bmi!),
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyWhite,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.defaultSpace),
                ElevatedButton(
                  onPressed: _navigateToDisease,
                  style: AppStyles.elevatedButtonStyle,
                  child: Text(AppText.next, style: AppStyles.buttonText),
                ),
              ],
              const SizedBox(height: AppSizes.bottomSpace),
            ],
          ),
        ),
      ),
    );
  }

  String _bmiSuggestion(double bmi) {
    if (bmi < 16) return AppText.bmiSeverelyUnderweight;
    if (bmi < 17) return AppText.bmiModeratelyUnderweight;
    if (bmi < 18.5) return AppText.bmiMildThinness;
    if (bmi < 25) return AppText.bmiNormal;
    if (bmi < 30) return AppText.bmiOverweight;
    if (bmi < 35) return AppText.bmiObese1;
    if (bmi < 40) return AppText.bmiObese2;
    return AppText.bmiObese3;
  }

  String _bmiCategory(double bmi) {
    if (bmi < 16) return 'Severely Underweight';
    if (bmi < 17) return 'Moderately Underweight';
    if (bmi < 18.5) return 'Mild Thinness';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    if (bmi < 40) return 'Obese Class II';
    return 'Obese Class III';
  }

  IconData _bmiIcon(double bmi) {
    if (bmi < 18.5) return Icons.warning_amber_rounded;
    if (bmi < 25) return Icons.check_circle_outline;
    if (bmi < 30) return Icons.directions_run;
    return Icons.health_and_safety;
  }

  List<Color> _bmiGradientColors(double bmi) {
    if (bmi < 16) return [Colors.red.shade900, Colors.red];
    if (bmi < 17) return [Colors.red, Colors.deepOrange];
    if (bmi < 18.5) return [Colors.orange, Colors.deepOrangeAccent];
    if (bmi < 25) return [Colors.green, Colors.teal];
    if (bmi < 30) return [Colors.yellow.shade700, Colors.orange];
    if (bmi < 35) return [Colors.deepOrange, Colors.orangeAccent];
    if (bmi < 40) return [Colors.deepOrange.shade900, Colors.red];
    return [Colors.redAccent, Colors.red];
  }
}
