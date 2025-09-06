import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movewise/services/auth_service.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/constants/app_icons.dart';
import 'package:movewise/core/constants/app_images.dart';
import 'package:movewise/core/utils/app_styles.dart';
import '../../widgets/custom_appbar.dart'; // ✅ Custom AppBar

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  /// Save login status in cache
  Future<void> _setLoginCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
  }

  /// Email/password login
  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().signInWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        await _setLoginCache(); // ✅ Save login in cache
        Get.offAllNamed(RouteName.DashboardScreen);
      } catch (e) {
        Get.snackbar(
          "Login Failed",
          e.toString(),
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon,
      {bool isPassword = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppStyles.hint,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(
          isPasswordVisible ? AppIcons.visibility : AppIcons.visibilityOff,
          color: Colors.grey,
        ),
        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
      )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.loginTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppText.loginWelcome, style: AppStyles.screenTitle),
              const SizedBox(height: AppSizes.gapLarge),

              // Email
              Text(AppText.emailLabel, style: AppStyles.label),
              const SizedBox(height: AppSizes.gapSmall),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(AppText.emailHint, AppIcons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppText.emailRequired;
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppText.emailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.gapMedium),

              // Password
              Text(AppText.passwordLabel, style: AppStyles.label),
              const SizedBox(height: AppSizes.gapSmall),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: _buildInputDecoration(
                    AppText.passwordHint, AppIcons.lock,
                    isPassword: true),
                validator: (value) =>
                (value == null || value.length < 6) ? AppText.passwordInvalid : null,
              ),
              const SizedBox(height: AppSizes.gapSmall),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(RouteName.ForgotPassword),
                  child: Text(AppText.forgotPassword, style: AppStyles.linkText),
                ),
              ),
              const SizedBox(height: AppSizes.gapLarge),

              // Email Login Button
              Center(
                child: SizedBox(
                  width: screenWidth * 0.85,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: AppStyles.elevatedButtonStyle,
                    child: Text(AppText.loginButton, style: AppStyles.buttonText),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.gapMedium),
              // Center(child: Text("OR", style: AppStyles.label)),
               const SizedBox(height: AppSizes.gapSmall),

              // Google Login
              SizedBox(
                width: screenWidth * 0.85,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await AuthService().signInWithGoogle();
                      await _setLoginCache(); // ✅ Save login for Google
                      Get.offAllNamed(RouteName.DashboardScreen);
                    } catch (e) {
                      Get.snackbar(
                        "Google Sign-In Failed",
                        e.toString(),
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    // shape: RoundedRectangleBorder(
                    //  // borderRadius: BorderSizes.radiusMedium,
                    //   side: const BorderSide(color: Colors.grey),
                    // ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.googleLogo, height: 24, width: 24),
                      const SizedBox(width: 10),
                      const Text(
                        "Continue with Google",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.gapLarge),

              // Signup Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppText.signupPrompt, style: AppStyles.label),
                  TextButton(
                    onPressed: () => Get.toNamed(RouteName.SignupScreen),
                    child: Text(AppText.signupButton, style: AppStyles.linkText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
