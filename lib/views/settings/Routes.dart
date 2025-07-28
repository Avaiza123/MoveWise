import 'package:flutter/material.dart';

// Auth Screens
import '/views/auth/LoginScreen.dart';

// Dashboard
import '/views/dashboard/dashboard_screen.dart';

// Onboarding Screens
import '/views/onboarding/welcome_screen.dart';
import '/views/onboarding/gender_screen.dart';
import '/views/onboarding/height_screen.dart';
import '/views/onboarding/weight_screen.dart';
import '/views/onboarding/goal_screen.dart';
import '/views/onboarding/DietScreen.dart';
import '/views/onboarding/disease_inspection_screen.dart';

class Routes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  // Onboarding screens
  static const String gender = '/onboarding/gender';
  static const String height = '/onboarding/height';
  static const String weight = '/onboarding/weight';
  static const String goal = '/onboarding/goal';
  static const String diet = '/onboarding/diet';
  static const String diseaseInspection = '/onboarding/disease-inspection';

  static Map<String, WidgetBuilder> all = {
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),

    // Onboarding flow
    gender: (context) => const GenderScreen(),
    height: (context) => const HeightScreen(),
    weight: (context) => const WeightScreen(),
    goal: (context) => const GoalScreen(),
    diet: (context) => const DietScreen(),
    diseaseInspection: (context) => const DiseaseScreen(),
  };
}
