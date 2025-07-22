import 'package:flutter/material.dart';

// Onboarding Screens
import 'views/onboarding/welcome_screen.dart';
import 'views/onboarding/gender_screen.dart';
import 'views/onboarding/goal_screen.dart';
// import 'views/onboarding/experience_screen.dart';
// import 'views/onboarding/activity_screen.dart';
// import 'views/onboarding/diet_screen.dart';
import 'views/onboarding/height_screen.dart';
import 'views/onboarding/weight_screen.dart';
import 'views/onboarding/disease_inspection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoveWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/gender': (context) => const GenderScreen(),
        '/goal': (context) => const GoalScreen(),
        // '/experience': (context) => const ExperienceScreen(),
        // '/activity': (context) => const ActivityScreen(),
        // '/diet': (context) => const DietScreen(),
        '/height': (context) => const HeightScreen(),
        '/weight': (context) => const WeightScreen(),
        '/disease': (context) => const DiseaseScreen(),
      },
    );
  }
}
