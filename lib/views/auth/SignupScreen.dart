import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/constants/app_icons.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppText.registrationSuccess)),
        );

        Get.offNamed(RouteName.LoginScreen);
      } on FirebaseAuthException catch (e) {
        String errorMessage = AppText.registrationFailed;
        if (e.code == 'email-already-in-use') {
          errorMessage = AppText.emailAlreadyInUse;
        } else if (e.code == 'weak-password') {
          errorMessage = AppText.passwordTooWeak;
        } else {
          errorMessage = e.message ?? errorMessage;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppStyles.hint,
      filled: true,
      fillColor: AppColors.white,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.signUp),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.createAccount, style: AppStyles.screenTitle),
                const SizedBox(height: AppSizes.gapLarge),

                // Username
                Text(AppText.username, style: AppStyles.label),
                const SizedBox(height: AppSizes.gapSmall),
                TextFormField(
                  controller: _usernameController,
                  style: AppStyles.input,
                  decoration: _buildInputDecoration(AppText.usernameHint, AppIcons.username),
                  validator: (value) =>
                  value == null || value.isEmpty ? AppText.usernameRequired : null,
                ),
                const SizedBox(height: AppSizes.gapMedium),

                // Email
                Text(AppText.email, style: AppStyles.label),
                const SizedBox(height: AppSizes.gapSmall),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppStyles.input,
                  decoration: _buildInputDecoration(AppText.emailHint, AppIcons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) return AppText.emailRequired;
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return AppText.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.gapMedium),

                // Password
                Text(AppText.password, style: AppStyles.label),
                const SizedBox(height: AppSizes.gapSmall),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: AppStyles.input,
                  decoration: _buildInputDecoration(AppText.passwordHint, AppIcons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.length < 6 ? AppText.passwordTooShort : null,
                ),
                const SizedBox(height: AppSizes.gapMedium),

                // Confirm Password
                Text(AppText.confirmPassword, style: AppStyles.label),
                const SizedBox(height: AppSizes.gapSmall),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  style: AppStyles.input,
                  decoration: _buildInputDecoration(AppText.confirmPasswordHint, AppIcons.lock)
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return AppText.passwordMismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.gapLarge),

                // Sign Up Button with gradient
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(AppText.signUp, style: AppStyles.buttonText.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.gapLarge),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppText.alreadyHaveAccount, style: AppStyles.label),
                    TextButton(
                      onPressed: () {
                        Get.offNamed(RouteName.LoginScreen);
                      },
                      child: Text(AppText.login, style: AppStyles.linkText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
