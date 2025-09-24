import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_icons.dart';
import '../../core/res/routes/route_name.dart';
import '../../widgets/custom_appbar.dart';
import '../../view_models/profile_vm.dart';

class MeScreen extends StatelessWidget {
  MeScreen({super.key});
  final ProfileVM profileVM = Get.put(ProfileVM());

  Widget _buildStatBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.3),
              AppColors.primaryColor.withOpacity(0.3)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColorDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryColor.withOpacity(0.2),
              child: Icon(icon, color: AppColors.primaryColorDark, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      shadowColor: color.withOpacity(0.3),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : "-",
          style: GoogleFonts.openSans(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: "My Profile"),
      body: Obx(() {
        if (profileVM.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileVM.error.value.isNotEmpty) {
          return Center(
            child: Text(
              profileVM.error.value,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
            ),
          );
        }

        final username = profileVM.name.value.isNotEmpty
            ? profileVM.name.value
            : "User";
        final email = profileVM.email.value;
        final weight =
        profileVM.weight.value.isNotEmpty ? profileVM.weight.value : "--";
        final height =
        profileVM.height.value.isNotEmpty ? profileVM.height.value : "--";
        final bmi =
        profileVM.bmi.value.isNotEmpty ? profileVM.bmi.value : "--";
        final gender =
        profileVM.gender.value.isNotEmpty ? profileVM.gender.value : "-";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header with gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.2),
                      AppColors.primaryColor.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.primaryColorDark,
                      child: Text(
                        username.isNotEmpty
                            ? username[0].toUpperCase()
                            : "?",
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      username,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Stats Row with gradient boxes
                    Row(
                      children: [
                        _buildStatBox("$weight Kg", "Weight"),
                        const SizedBox(width: 10),
                        _buildStatBox("$height cm", "Height"),
                        const SizedBox(width: 10),
                        _buildStatBox("$bmi", "BMI"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Info Cards

              const SizedBox(height: 20),

              // Options
              _buildOption(
                title: "About",
                icon: AppIcons.info,
                onTap: () => Get.toNamed(RouteName.AboutScreen),
              ),
              _buildOption(
                title: "Edit Profile",
                icon: AppIcons.edit,
                onTap: () => Get.toNamed(RouteName.ProfileScreen),
              ),
              _buildOption(
                title: "Q & A",
                icon: AppIcons.question,
                onTap: () => Get.toNamed(RouteName.QnaScreen),
              ),
            ],
          ),
        );
      }),
    );
  }
}
