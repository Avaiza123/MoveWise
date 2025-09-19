import 'package:flutter/material.dart';

class AppColors {
  // 🔥 Primary Brand Colors
  static const Color primaryColor = Color(0xFF8C5A3C); // Vibrant teal-green
  static const Color primaryColorDark = Color(0xFF6B4226); // Deep teal
  static const Color accentColor = Color(0xFF6B4226); // Energetic purple accent

  // Buttons
  static const Color buttonColor = primaryColor;
  // static const Color gradientStart = Color(0xFF00C9A7); // Fresh green-teal
  // static const Color gradientEnd = Color(0xFF007991); // Dark teal
  // Text
  // Gradient (Brown Theme)
  // static const Color gradientStart = Color(0xFF8B5E3C); // Warm coffee brown
  // static const Color gradientEnd   = Color(0xFFD4A373); // Amber-golden complement
  // Primary Gradient (Strong + Energetic)
  static const Color gradientStart = Color(0xFF6B4226); // Deep Espresso Brown
  static const Color gradientEnd   = Color(0xFFD4A373); // Soft Caramel Beige

// Secondary Gradient (Modern + Smooth)
  static const Color secondaryStart = Color(0xFF8C5A3C); // Warm Mocha
  static const Color secondaryEnd   = Color(0xFFE6CBA8); // Creamy Sand

// Accent Gradient (Energy + Motivation)
  static const Color accentStart = Color(0xFFB87333); // Copper Glow
  static const Color accentEnd   = Color(0xFFF5DEB3); // Wheat Beige
  //
  // static const Color gradientStart = Color(0xFF4E342E); // Deep chocolate brown
  // static const Color gradientEnd   = Color(0xFFCC7722); // Copper / burnt orange

  static const Color textColor = Color(0xFF212121);
  static const Color textSubtleColor = Color(0xFF6D6D6D);

  // Backgrounds
  static const Color backgroundColor = Color(0xFFFFFAF0);
  static const Color cardBackground = Colors.white;

  // Gradient for AppBar / Buttons / Highlights
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static final Color shadowColor = Colors.black.withOpacity(0.1);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Extra States
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);

  // Text Input Fields
  static const Color primaryTextColor = Color(0xFF2D2C2C);
  static const Color hintTextColor = Color(0xFFA6A3A3);



  static const Color primary = Color(0xFF6C63FF); // Based on Figma
  static const Color secondary = Color(0xFFFFB800);
  static const Color background = Color(0xFFF5F6FA);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF888888);
  static const Color accent = Color(0xFFFF6F61);

  static const Color lavender = Color(0xFFE4C9F9);
  static const Color yellow = Color(0xFFFFE99D);
  static const Color mint = Color(0xFFAAF1CB);
  static const Color pink = Color(0xFFFFA5B8);
  static const Color peach = Color(0xFFFFD18B);
  static const Color gray = Color(0xFFC5CFD6);
  static const Color sky = Color(0xFFC2DEFF);
  static const Color orange = Color(0xFFFF922B);
  static const Color lilac = Color(0xFFE9E9FF);
  static const Color teal = Color(0xFF73DBD5);
  static const Color bg = Color(0xFFF9FAFB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFE0E0E0);


  // Icon Colors (vibrant)
  static const Color red = Color(0xFFFF6B6B);
  static const Color green = Color(0xFF51CF66);
  static const Color blue = Color(0xFF349CF3);
  static const Color purple = Color(0xFF845EF7);
  static const Color pinkAccent = Color(0xFFF06595);


}
