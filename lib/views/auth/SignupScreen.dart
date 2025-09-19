import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
        Get.offNamed(RouteName.GenderScreen);
       // Get.offNamed(RouteName.LoginScreen);
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
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.grey[500],
      ),
      filled: true,
      fillColor: AppColors.white,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.s38),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.s38),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.85;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: AppText.signUp),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0), // left padding for whole page
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppText.createAccount,
                          style: GoogleFonts.amarante(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: fieldWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Username
                            Text(AppText.username,
                                style: GoogleFonts.acme(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _usernameController,
                              style: GoogleFonts.inter(fontSize: 16),
                              decoration: _buildInputDecoration(
                                  AppText.usernameHint, AppIcons.username),
                              validator: (value) => value == null || value.isEmpty
                                  ? AppText.usernameRequired
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            Text(AppText.email,
                                style: GoogleFonts.acme(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.inter(fontSize: 16),
                              decoration: _buildInputDecoration(
                                  AppText.emailHint, AppIcons.email),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppText.emailRequired;
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return AppText.invalidEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password
                            Text(AppText.password,
                                style: GoogleFonts.acme(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              style: GoogleFonts.inter(fontSize: 16),
                              decoration: _buildInputDecoration(
                                  AppText.passwordHint, AppIcons.lock)
                                  .copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(
                                          () => _isPasswordVisible = !_isPasswordVisible),
                                ),
                              ),
                              validator: (value) => value == null || value.length < 6
                                  ? AppText.passwordTooShort
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password
                            Text(AppText.confirmPassword,
                                style: GoogleFonts.acme(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 9),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              style: GoogleFonts.inter(fontSize: 18),
                              decoration: _buildInputDecoration(
                                  AppText.confirmPasswordHint, AppIcons.lock)
                                  .copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(() => _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible),
                                ),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return AppText.passwordMismatch;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Sign Up Button
                            Center(
                              child: Container(
                                width: fieldWidth * 0.8,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)),
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                      color: Colors.white)
                                      : Text(AppText.signUp,
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Already have account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppText.alreadyHaveAccount,
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: Colors.grey[700])),
                                TextButton(
                                  onPressed: () {
                                    Get.offNamed(RouteName.LoginScreen);
                                  },
                                  child: Text(AppText.login,
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
