import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_colors.dart';

class AppStyles {
  // AppBar title
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static const TextStyle snackBarTextStyle = TextStyle(
    fontSize: AppSizes.fontSizeMd,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  // static final elevatedButtonStyle = ElevatedButton.styleFrom(
  //   backgroundColor: Colors.teal,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  // );
  static AppBar customAppBar(String title) {
    return AppBar(
      backgroundColor: AppColors.appBarColor,
      elevation: 6,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
    );
  }
  static const TextStyle cardText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static TextStyle appBarTitle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // General screen title
  static TextStyle screenTitle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  // Button Text
  static TextStyle buttonText = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Wheel text selected
  static TextStyle wheelSelectedText = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonColor,
  );


  static const TextStyle input = TextStyle(
    fontSize: 14,
    color: AppColors.primaryTextColor,
  );


  // Toggle text
  static TextStyle toggleText = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  // Label text style
  static TextStyle label = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black38,
  );

  // Value text style
  static TextStyle value = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonColor,
  );
  static final TextStyle linkText = TextStyle(
    color: AppColors.primary,
    fontSize: AppSizes.fontSizeSm,
    fontWeight: FontWeight.w500,
  );

  // Global ElevatedButton style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonColor,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 10,
    shadowColor: AppColors.buttonColor,
  );
  static const bodyWhite = TextStyle(
    fontSize: AppSizes.fontSizeMd,
    color: AppColors.primaryColorDark,
  );

  static final bodyBlack = TextStyle(
    fontSize: AppSizes.fontSizeMd,
    color: AppColors.blackColor,
  );

  static const headingWhite = TextStyle(
    fontSize: AppSizes.fontSizeLg,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColorDark,
  );

  static final headingBlack = TextStyle(
    fontSize: AppSizes.fontSizeLg,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );


  static final BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.black.withOpacity(0.3),
    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
  );

  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.xl,
      vertical: AppSizes.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
    ),
  );



  // For input hint texts like "Enter your email"
  static const TextStyle hint = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.hintTextColor,
  );
  static const TextStyle subtitleText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

}
