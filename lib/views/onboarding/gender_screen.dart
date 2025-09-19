import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/constants/app_icons.dart';
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
      selectedGender = gender;
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
              const Icon(AppIcons.info, color: Colors.white),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  AppText.genderSelectionError,
                  style: AppStyles.snackBarTextStyle,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.buttonColor,
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
    required IconData icon,
  }) {
    final isSelected = selectedGender == label;

    return GestureDetector(
      onTap: () => _selectGender(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        width: 300, // Centered and smaller width
        // Centered and smaller width
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.md,
          horizontal: AppSizes.mdLg,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), // Rounded pill shape
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.4)
              : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center, // Center content
          children: [
            Icon(
              icon,
              size: AppSizes.iconLg,
              color: isSelected ? AppColors.primaryColorDark : Colors.grey[800],
            ),
            const SizedBox(width: AppSizes.md),
            Text(
              label,
              style: GoogleFonts.acme(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryColorDark : Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.selectYourGenderTitle),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.genderQuestion,
                style: GoogleFonts.aboreto(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.md),
            Text(AppText.genderSubText,
                style: GoogleFonts.poppins(
                    fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: AppSizes.xl),

            // Gender Options Centered
            Center(
              child: Column(
                children: [
                  _buildGenderCard(label: AppText.genderMale, icon: AppIcons.male),
                  _buildGenderCard(label: AppText.genderFemale, icon: AppIcons.female),
                  _buildGenderCard(
                      label: AppText.genderPreferNotToSay,
                      icon: AppIcons.preferNotToSay),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Continue Button Oval
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: fieldWidth * 0.6, // Oval
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(50), // Oval
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _navigateNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text(
                    AppText.continueButton,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
