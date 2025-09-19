import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_texts.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/app_styles.dart';
import '../../core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  String selectedUnit = 'kg';
  double weight = 60; // ✅ default weight
  double? bmi;        // ✅ numeric BMI

  void _navigateToDisease() {
    Get.toNamed(RouteName.DietScreen);
  }

  Future<void> _calculateBMI(double heightCm) async {
    // 🔹 Convert weight for calculation only
    double weightKg = selectedUnit == 'kg' ? weight : (weight * 0.453592);
    double heightM = heightCm / 100;

    setState(() {
      bmi = weightKg / pow(heightM, 2);
    });

    // Save locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', weight); // ✅ save in selected unit
    await prefs.setString('weight_unit', selectedUnit);
    await prefs.setDouble('bmi', bmi!);
    await prefs.setBool('onboarding_done', false);

    // 🔥 Save to Firestore → inside profile
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "test_user";

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        "profile": {
          "weight": weight.round(),          // ✅ number
          "weightUnit": selectedUnit,        // ✅ kg / lb
          "bmi": bmi!.toStringAsFixed(1),    // ✅ keep as string (e.g., "22.5")
        },
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("⚠️ Error saving to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Always get normalized cm from HeightScreen
    final double heightCm = Get.arguments as double;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectWeight),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Unit Toggle
              ToggleButtons(
                isSelected: [selectedUnit == 'kg', selectedUnit == 'lb'],
                onPressed: (index) {
                  setState(() {
                    selectedUnit = index == 0 ? 'kg' : 'lb';
                  });
                },
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                selectedColor: AppColors.white,
                fillColor: AppColors.primaryColor,
                textStyle: AppStyles.toggleText,
                children: const [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('KG')),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('LB')),
                ],
              ),

              const SizedBox(height: AppSizes.spaceBetweenItem),

              /// Weight Display in Box
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.md,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '${weight.round()} $selectedUnit',
                  style: AppStyles.screenTitle.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: AppSizes.spaceBetweenItem),

              /// Horizontal Weight Selector
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 500,
                  itemBuilder: (context, index) {
                    double value = index.toDouble();
                    final isSelected = weight.round() == value.round();
                    return GestureDetector(
                      onTap: () => setState(() => weight = value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          gradient:
                          isSelected ? AppColors.primaryGradient : null,
                          color: isSelected
                              ? null
                              : Colors.grey.shade300.withOpacity(0.3),
                          borderRadius:
                          BorderRadius.circular(AppSizes.cardRadius),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                                color: AppColors.primaryColor
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4))
                          ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          value.round().toString(),
                          style: AppStyles.bodyWhite.copyWith(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: isSelected ? 18 : 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSizes.spaceBetweenItem),

              /// Calculate BMI Button
              ElevatedButton(
                onPressed: () => _calculateBMI(heightCm),
                style: AppStyles.buttonStyle,
                child: Text(AppText.calculateBMI, style: AppStyles.buttonText),
              ),

              const SizedBox(height: AppSizes.defaultSpace),

              /// BMI Result Display
              if (bmi != null) ...[
                SizedBox(
                  height: 250,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 10,
                        maximum: 50,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: 10,
                              endValue: 16,
                              color: Colors.red.shade900),
                          GaugeRange(
                              startValue: 16,
                              endValue: 17,
                              color: Colors.red),
                          GaugeRange(
                              startValue: 17,
                              endValue: 18.5,
                              color: Colors.orange),
                          GaugeRange(
                              startValue: 18.5,
                              endValue: 25,
                              color: Colors.teal),
                          GaugeRange(
                              startValue: 25,
                              endValue: 30,
                              color: Colors.yellow),
                          GaugeRange(
                              startValue: 30,
                              endValue: 35,
                              color: Colors.orangeAccent),
                          GaugeRange(
                              startValue: 35,
                              endValue: 40,
                              color: Colors.deepOrange),
                          GaugeRange(
                              startValue: 40,
                              endValue: 50,
                              color: Colors.redAccent),
                        ],
                        pointers: <GaugePointer>[NeedlePointer(value: bmi!)],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text('BMI: ${bmi!.toStringAsFixed(1)}',
                                style: AppStyles.headingWhite
                                    .copyWith(fontSize: 20)),
                            angle: 90,
                            positionFactor: 0.7,
                          )
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.defaultSpace),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(AppSizes.cardPadding),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _bmiGradientColors(bmi!),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
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
                      Icon(_bmiIcon(bmi!), size: 50, color: Colors.white),
                      const SizedBox(height: 12),
                      Text(_bmiCategory(bmi!),
                          style: AppStyles.screenTitle
                              .copyWith(color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(_bmiSuggestion(bmi!),
                          textAlign: TextAlign.center,
                          style: AppStyles.bodyWhite),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.defaultSpace),

                ElevatedButton(
                  onPressed: _navigateToDisease,
                  style: AppStyles.buttonStyle,
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
