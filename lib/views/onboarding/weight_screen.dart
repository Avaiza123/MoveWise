import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:google_fonts/google_fonts.dart';
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
          padding: const EdgeInsets.all(AppSizes.s12),
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

            //  const SizedBox(height: AppSizes.spaceBetweenItem),
              const SizedBox(height: AppSizes.s8),
              /// Weight Display in Box
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.md,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.s180),
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
             // const SizedBox(height: AppSizes.spaceBetweenItem),
              const SizedBox(height: AppSizes.s20),
              /// Horizontal Weight Selector
              SizedBox(
                height: 65,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 500,
                  itemBuilder: (context, index) {
                    double value = index.toDouble();
                    final isSelected = weight.round() == value.round();
                    return GestureDetector(
                      onTap: () => setState(() => weight = value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          gradient:
                          isSelected ? AppColors.primaryGradient.withOpacity(0.8) : null,
                          color: isSelected
                              ? null
                              : Colors.grey.shade500.withOpacity(0.3),
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

              const SizedBox(height: AppSizes.s12),

              /// Calculate BMI Button
              Center(
                child: SizedBox(
                  width: 230, // adjust width like Next button
                  height: 60, // adjust height like Next button
                  child: ElevatedButton(
                    onPressed: () => _calculateBMI(heightCm),
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
                          AppText.calculateBMI,
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


              const SizedBox(height: AppSizes.s8),

              /// BMI Result Display
              if (bmi != null) ...[
                SizedBox(
                  height: 240,
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

                const SizedBox(height: AppSizes.s4),
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.all(AppSizes.cardPadding),
                    width: MediaQuery.of(context).size.width * 0.67, // 🔹 narrower than full width
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_bmiIcon(bmi!), size: 28, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            _bmiCategory(bmi!),
                            style: GoogleFonts.acme(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _bmiSuggestion(bmi!),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )

                ),
                ),
                const SizedBox(height: AppSizes.s12),


      Center(
        child: SizedBox(
          width: 140, // same width as Next button
          height: 60, // same height as Next button
          child: ElevatedButton(
            onPressed: _navigateToDisease,
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
                  AppText.next,
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


      const SizedBox(height: AppSizes.bottomSpace),
            ],
         ] ),
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
