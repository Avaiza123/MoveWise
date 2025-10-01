import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import 'package:movewise/views/Me/about.dart';
import 'package:movewise/views/Me/me.dart';
import 'package:movewise/views/Me/qna.dart';
import 'package:movewise/views/auth/LoginScreen.dart';
import 'package:movewise/views/auth/SignupScreen.dart';
import 'package:movewise/views/chatbot/chatbot_screen.dart';
import 'package:movewise/views/dashboard/dashboard_screen.dart';
import 'package:movewise/views/Me/profile.dart';
import 'package:movewise/views/exercise/exercise_plan_screen.dart';
import 'package:movewise/views/nutrition/nutrition_screen.dart';
import 'package:movewise/views/onboarding/DietScreen.dart';
import 'package:movewise/views/onboarding/goal_screen.dart';
import 'package:movewise/views/onboarding/height_screen.dart';
import 'package:movewise/views/onboarding/weight_screen.dart';
import 'package:movewise/views/onboarding/welcome_screen.dart';
import 'package:movewise/views/splash_screen.dart';
import 'package:movewise/views/auth/ForgetPassword.dart';
import 'package:movewise/views/onboarding/gender_screen.dart';
import 'package:movewise/views/water_tracker/water_screen.dart';

import '../../../view_models/plan_vm.dart';
import '../../../views/plan/plan_screen.dart';


class AppRoute{

  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => const SplashScreen()
    ),
    GetPage(
        name: RouteName.welcomeScreen,
        page: () => const WelcomeScreen()
    ),
    GetPage(
        name: RouteName.GenderScreen,
        page: () => const GenderScreen()
    ),
    GetPage(
        name: RouteName.GoalScreen,
        page: () => const GoalScreen()
    ),
    GetPage(
        name: RouteName.HeightScreen,
        page: () => const HeightScreen()
    ),
    GetPage(
        name: RouteName.WeightScreen,
        page: () => const WeightScreen()
    ),
    GetPage(
        name: RouteName.DietScreen,
        page: () => const DietScreen()
    ),

    GetPage(
        name: RouteName.LoginScreen,
        page: () => const LoginScreen()
    ),
    GetPage(
        name: RouteName.SignupScreen,
        page: () => const SignUpScreen()
    ),
    GetPage(
        name: RouteName.ForgotPassword,
        page: () => const ForgotPasswordScreen()
    ),

    GetPage(
        name: RouteName.DashboardScreen,
        page: () => DashboardScreen()
    ),

    GetPage(
        name: RouteName.WaterTrackerScreen,
        page: () => WaterTrackerScreen()
    ),
    GetPage(
        name: RouteName.NutritionScreen,
        page: () => NutritionScreen()
    ),
    GetPage(
        name: (RouteName.ProfileScreen),
        page: () => ProfileScreen()
    ),
    GetPage(
        name: (RouteName.AboutScreen),
        page: () => AboutScreen()
    ),
    GetPage(
        name: (RouteName.QnaScreen),
        page: () => QnaScreen()
    ),
    GetPage(
        name: (RouteName.Me),
    page: () => MeScreen()
    ),
    GetPage(
        name: (RouteName.ChatBotScreen),
        page: () => ChatBotScreen()
    ),
    GetPage(
      name: RouteName.ExercisePlanScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return ExercisePlanScreen(
          title: args['title'],
          fileName: args['file'], // pass file/category name
        );
      },
    ),
    GetPage(
      name: RouteName.PlanScreen,
      page: () {
        Get.put(PlanVM(), permanent: true);
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final planIndex = args['planIndex'] ?? 0;
        return PlanScreen(planIndex: planIndex);
      },
    ),



  ];
}