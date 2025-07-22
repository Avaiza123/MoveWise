import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // AppBar title
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

  // Wheel text unselected
  static TextStyle wheelUnselectedText = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  // Toggle text
  static TextStyle toggleText = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  // Label text style
  static TextStyle label = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  // Value text style
  static TextStyle value = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonColor,
  );

  // Global ElevatedButton style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonColor,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 10,
    shadowColor: AppColors.buttonColor,
  );
}
