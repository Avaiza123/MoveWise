import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_texts.dart';
import '../../core/constants/app_images.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToValue());
  }

  void _scrollToValue() {
    final int minValue = selectedUnit == 'cm' ? 100 : 48;
    final double offset = (sliderValue - minValue) * 50;
    if (scrollController.hasClients) {
      scrollController.jumpTo(offset.clamp(
        0,
        scrollController.position.maxScrollExtent,
      ));
    }
  }

  Future<void> _saveHeightAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('height_unit', selectedUnit);
    await prefs.setBool('onboarding_done', false);

    Map<String, dynamic> heightData;

    if (selectedUnit == 'cm') {
      await prefs.setInt('height_cm', heightCm);
      heightData = {'height': heightCm, 'heightUnit': 'cm'};
    } else {
      String formattedHeight = "${heightFt}\'${heightIn}\"";
      await prefs.setString('height_ft_in', formattedHeight);
      heightData = {'height': formattedHeight, 'heightUnit': 'ft'};
    }

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "test_user";
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'profile': heightData,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("⚠️ Error saving height to Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to save height. Please try again."),
        ),
      );
      return;
    }

    final double passHeight = selectedUnit == 'cm'
        ? heightCm.toDouble()
        : ((heightFt * 12 + heightIn) * 2.54);

    Get.toNamed(RouteName.WeightScreen, arguments: passHeight);
  }

  @override
  Widget build(BuildContext context) {
    final int minValue = selectedUnit == 'cm' ? 100 : 48;
    final int maxValue = selectedUnit == 'cm' ? 220 : 84;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectYourHeight),
      body: SafeArea(
        child: Column(
          children: [
            // Unit selection
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: ToggleButtons(
                isSelected: [selectedUnit == 'cm', selectedUnit == 'ft/in'],
                onPressed: (index) {
                  setState(() {
                    selectedUnit = index == 0 ? 'cm' : 'ft/in';
                    sliderValue = selectedUnit == 'cm'
                        ? heightCm.toDouble()
                        : (heightFt * 12 + heightIn.toDouble());
                    _scrollToValue();
                  });
                },
                color: Colors.grey[400],
                selectedColor: AppColors.primaryColor,
                fillColor: AppColors.white,
                borderColor: Colors.grey,
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
            ),

            const SizedBox(height: AppSizes.sm),

            // Display height value
            Text(
              selectedUnit == 'cm'
                  ? "$heightCm cm"
                  : "$heightFt'${heightIn}\"",
              style: AppStyles.headingWhite.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // Body: Scale + Person
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Vertical Scale
                  Container(
                    width: 80,
                    child: ListView.builder(
                      controller: scrollController,
                      reverse: true,
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
                            });
                          },
                          child: Container(
                            height: 50, // taller for better spacing
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                // Scale line
                                Container(
                                  width: isSelected ? 20: 15,
                                  height: 2,

                                  color: isSelected
                                      ? AppColors.accentColor
                                      : Colors.grey[700],
                                ),
                                const SizedBox(width: 8),
                                // Value
                                Text(
                                  selectedUnit == 'cm'
                                      ? "$value"
                                      : "${value ~/ 12}'${value % 12}\"",
                                  style: TextStyle(
                                    fontSize: isSelected ? 15 : 14,
                                    color: isSelected
                                        ? AppColors.accentColor
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.w900
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

                  // Person image
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      final maxHeight = constraints.maxHeight * 0.9;
                      final personHeight = 50 +
                          ((sliderValue - minValue) / (maxValue - minValue)) *
                              (maxHeight - 50);

                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          AppImages.people,
                          height: personHeight,
                          fit: BoxFit.contain,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Slider
            Slider(
              value: sliderValue,
              min: minValue.toDouble(),
              max: maxValue.toDouble(),
              divisions: maxValue - minValue,
              activeColor: AppColors.accentColor,
              inactiveColor: Colors.grey[800],
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                  if (selectedUnit == 'cm') {
                    heightCm = value.round();
                  } else {
                    heightFt = value ~/ 12;
                    heightIn = (value % 12).round();
                  }
                  scrollController.animateTo(
                    (value - minValue) * 50,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                });
              },
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s90, vertical: AppSizes.sm),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: _saveHeightAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text(
                    AppText.next,
                    style: AppStyles.buttonText.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
