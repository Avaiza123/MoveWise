import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import 'package:movewise/core/constants/app_images.dart'; // <-- Add this import


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleNavigation() async {
    Get.toNamed(RouteName.GenderScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.splashBackground,
              fit: BoxFit.cover,
            ),
          ),
          Container(color: AppColors.blackColor.withOpacity(0.6)),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset(AppImages.splashLogo ),
                    ),
                    const SizedBox(height: AppSizes.defaultSpace),
                    ElevatedButton(
                      onPressed: _handleNavigation,
                      style: AppStyles.elevatedButtonStyle,
                      child: Text(
                        AppText.getStarted,
                        style: AppStyles.buttonText,
                      ),
                    ),
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
