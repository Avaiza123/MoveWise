import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/constants/app_images.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen>
    with SingleTickerProviderStateMixin {
  String? selectedGender;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = selectedGender == gender ? null : gender;
      _controller.forward(from: 0);
    });
  }

  Future<void> _saveUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', false);
    await prefs.setString('selected_gender', selectedGender ?? "");

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && selectedGender != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDoc.set({
        'profile': {'gender': selectedGender}
      }, SetOptions(merge: true));
    }
  }

  Future<void> _navigateNext() async {
    if (selectedGender != null) {
      await _saveUserInfo();
      Get.toNamed(RouteName.GoalScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  AppText.genderSelectionError,
                  style: AppStyles.snackBarTextStyle,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.s48),
          ),
          elevation: 8,
          margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.defaultSpace, vertical: AppSizes.sm),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildGenderCard({
    required String label,
    required String imagePath,
  }) {
    final isSelected = selectedGender == label;
    final borderColor = isSelected ? AppColors.primaryColor : Colors.grey.shade200;

    return GestureDetector(
      onTap: () => _selectGender(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        width: 160,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3.0 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? borderColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 10 : 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryColor : Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(
        title: AppText.gender,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.xl),
            Text(
              'Which option best describes you?',
              style: GoogleFonts.aboreto(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.yellow.shade700),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Text(
                      'Select your gender to continue your journey and unlock a personalized experience designed just for you.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // Male/Female options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGenderCard(
                  label: 'Man',
                  imagePath: AppImages.male,
                ),
                const SizedBox(height: AppSizes.s12),
                _buildGenderCard(
                  label: 'Woman',
                  imagePath: AppImages.female,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.lg),

            // Prefer not to say
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: selectedGender == 'Prefer not to say',
                    onChanged: (bool? value) {
                      _selectGender('Prefer not to say');
                    },
                    activeColor: AppColors.primaryColor,
                    checkColor: Colors.white,
                  ),
                  Text(
                    'Prefer not to say',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.sm),

            // Next button
            Center(
              child: SizedBox(
                width: 140,
                height: 60,
                child: ElevatedButton(
                  onPressed: _navigateNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }
}
