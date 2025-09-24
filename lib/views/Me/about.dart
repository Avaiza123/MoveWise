import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewise/core/constants/app_images.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFBE9E7),
            Color(0xFFD7CCC8),
            Color(0xFFEFEBE9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: "About"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 App Logo / Icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                 AppImages.splashLogo, // ✅ replace with your logo path
                  height: 180,
                  width: 180,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Title
              Text(
                "MoveWise",
                style: GoogleFonts.aboreto(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown.shade900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your Personal Fitness Companion",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Info Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoItem(
                      icon: Icons.track_changes,
                      title: "Track Your Goals",
                      desc: "Set personalized goals and monitor your daily progress with ease.",
                    ),
                    const Divider(),
                    _buildInfoItem(
                      icon: Icons.health_and_safety,
                      title: "Health Insights",
                      desc: "Get science-backed BMI & lifestyle recommendations tailored to you.",
                    ),
                    const Divider(),
                    _buildInfoItem(
                      icon: Icons.emoji_events,
                      title: "Stay Motivated",
                      desc: "Celebrate milestones with achievements and keep pushing forward.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Footer
              Text(
                "Version 1.0.0",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "© 2025 MoveWise. All rights reserved.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable info row
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: AppColors.primaryColorDark),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                desc,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
