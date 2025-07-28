import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_texts.dart';
import 'package:movewise/core/utils/app_styles.dart';
import 'package:movewise/services/auth_service.dart';
import 'package:movewise/core/res/routes/route_name.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;

  const OTPVerificationScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  void _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppText.enterValidOtp)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.verifyOTP(widget.verificationId, otp);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppText.loginSuccess)),
      );

      /// Navigate to dashboard
      Get.offAllNamed(RouteName.DashboardScreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppText.invalidOtp)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppText.otpVerification, style: AppStyles.appBarTitle),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppText.enterOtpSentToPhone,
              style: AppStyles.subtitleText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: AppText.otp,
                labelStyle: AppStyles.label,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: AppStyles.input,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  AppText.verify,
                  style: AppStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
