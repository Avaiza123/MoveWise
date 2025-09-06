import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';

class AppStyles {
  // AppBar title
  static final TextStyle heading = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColorDark,
  );
  static final ButtonStyle gradientButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
  );
  static final TextStyle snackBarTextStyle = GoogleFonts.roboto(
    fontSize: AppSizes.fontSizeMd,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static AppBar customAppBar(String title) {
    return AppBar(
      backgroundColor: AppColors.primaryColorDark,
      elevation: 6,
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
    );
  }

  static final TextStyle cardText = GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

  static final TextStyle appBarTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // General screen title
  static final TextStyle screenTitle = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  // Button Text
  static final TextStyle buttonText = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Wheel text selected
  static final TextStyle wheelSelectedText = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonColor,
  );

  static final TextStyle input = GoogleFonts.roboto(
    fontSize: 14,
    color: AppColors.primaryTextColor,
  );

  // Toggle text
  static final TextStyle toggleText = GoogleFonts.lato(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  // Label text style
  static final TextStyle label = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black45,
  );

  // Value text style
  static final TextStyle value = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonColor,
  );

  static final TextStyle linkText = GoogleFonts.roboto(
    color: AppColors.primaryColorDark,
    fontSize: AppSizes.fontSizeSm,
    fontWeight: FontWeight.w500,
  );

  // Global ElevatedButton style
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonColor,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 10,
    shadowColor: AppColors.buttonColor.withOpacity(0.6),
  );

  static final TextStyle bodyWhite = GoogleFonts.roboto(
    fontSize: AppSizes.fontSizeMd,
    color: AppColors.primaryColorDark,
  );

  static final TextStyle bodyBlack = GoogleFonts.roboto(
    fontSize: AppSizes.fontSizeMd,
    color: AppColors.black,
  );

  static final TextStyle headingWhite = GoogleFonts.poppins(
    fontSize: AppSizes.fontSizeLg,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColorDark,
  );

  static final TextStyle headingBlack = GoogleFonts.poppins(
    fontSize: AppSizes.fontSizeLg,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.black.withOpacity(0.05),
    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
  );

  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColorDark,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.xl,
      vertical: AppSizes.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
    ),
  );

  // Input hint texts
  static final TextStyle hint = GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.hintTextColor,
  );

  static final TextStyle subtitleText = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );
}
