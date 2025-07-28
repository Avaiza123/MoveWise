import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_images.dart';
import 'package:movewise/core/res/routes/route_name.dart';

import '../core/constants/app_texts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  late final Animation<double> _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), _handleNavigation);
  }

  Future<void> _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!mounted) return;

    if (!onboardingDone) {
      Get.offNamed(RouteName.welcomeScreen);
    } else if (!isLoggedIn) {
      Get.offNamed(RouteName.LoginScreen);
    } else {
      Get.offNamed(RouteName.DashboardScreen);
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.splashBackground, fit: BoxFit.cover),
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.6), // themed overlay
          ),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.splashLogo,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    SizedBox(height: AppSizes.defaultSpace),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        AppText.splashQuote,
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceBetweenItem),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
