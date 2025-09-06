import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import 'package:movewise/views/auth/LoginScreen.dart';
import 'package:movewise/views/auth/SignupScreen.dart';
import 'package:movewise/views/dashboard/dashboard_screen.dart';
import 'package:movewise/views/onboarding/DietScreen.dart';
import 'package:movewise/views/onboarding/disease_inspection_screen.dart';
import 'package:movewise/views/onboarding/goal_screen.dart';
import 'package:movewise/views/onboarding/height_screen.dart';
import 'package:movewise/views/onboarding/weight_screen.dart';
import 'package:movewise/views/onboarding/welcome_screen.dart';
import 'package:movewise/views/splash_screen.dart';
import 'package:movewise/views/auth/ForgetPassword.dart';
import 'package:movewise/views/onboarding/gender_screen.dart';


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
        name: RouteName.DiseaseScreen,
        page: () => const DiseaseScreen()
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
        page: () => const DashboardScreen()
    ),


  ];
}