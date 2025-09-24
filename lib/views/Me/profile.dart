import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view_models/profile_vm.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_texts.dart';
import '../../widgets/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileVM vm = Get.put(ProfileVM());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ Full background from top (even behind AppBar)
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFBE9E7), // Light warm beige
            Color(0xFFD7CCC8), // Neutral light brown
            Color(0xFFEFEBE9), // Cream
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // ✅ Transparent so background shows
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: CustomAppBar(title: AppText.profile),
        ),
        body: Obx(() {
          if (vm.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Keep controllers in sync in edit mode
          if (vm.isEditing.value) {
            nameController.text = vm.name.value;
            weightController.text = vm.weight.value;
            heightController.text = vm.height.value;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ Centered Profile Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColorDark.withOpacity(0.8),
                  child: Text(
                    vm.name.isNotEmpty ? vm.name.value[0].toUpperCase() : "?",
                    style: GoogleFonts.almendraSc(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.s16),

                Text(
                  vm.name.value.isNotEmpty ? vm.name.value : "User",
                  style: GoogleFonts.almendraSc(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.brown.shade900,
                  ),
                ),
                const SizedBox(height: AppSizes.s24),

                // ✅ Rounded container for content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.padding),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("Account Info"),
                      _buildField("Email", vm.email.value),
                      const SizedBox(height: AppSizes.s12),

                      _sectionTitle("Personal Info"),
                      _buildEditableField(
                        "Name",
                        vm.name.value,
                        nameController,
                        vm.isEditing.value,
                        onChanged: (v) => vm.name.value = v,
                      ),
                      const SizedBox(height: AppSizes.s12),

                      // ✅ Weight + Unit
                      Row(
                        children: [
                          Expanded(
                            child: _buildEditableField(
                              "Weight",
                              vm.weight.value,
                              weightController,
                              vm.isEditing.value,
                              onChanged: (v) => vm.weight.value = v,
                            ),
                          ),
                          const SizedBox(width: AppSizes.s12),
                          Expanded(
                            child: _buildField("Unit", vm.weightUnit.value),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.s12),

                      // ✅ Height + Unit
                      Row(
                        children: [
                          Expanded(
                            child: _buildEditableField(
                              "Height",
                              vm.height.value,
                              heightController,
                              vm.isEditing.value,
                              onChanged: (v) => vm.height.value = v,
                            ),
                          ),
                          const SizedBox(width: AppSizes.s12),
                          Expanded(
                            child: _buildField("Unit", vm.heightUnit.value),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.s12),

                      _buildField("BMI", vm.bmi.value),
                      const SizedBox(height: AppSizes.s24),

                      // ✅ Buttons
                      vm.isEditing.value
                          ? Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                              label: "Cancel",
                              icon: AppIcons.cancel,
                              color: Colors.grey.shade600,
                              onTap: () async => await vm.cancelEdit(),
                            ),
                          ),
                          const SizedBox(width: AppSizes.s12),
                          Expanded(
                            child: _buildButton(
                              label: "Save",
                              icon: AppIcons.save,
                              color: AppColors.primaryColorDark,
                              onTap: () => vm.saveProfile(),
                            ),
                          ),
                        ],
                      )
                          : _buildButton(
                        label: "Edit Profile",
                        icon: AppIcons.edit,
                        color: AppColors.primaryColorDark,
                        onTap: () => vm.enableEdit(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Section title
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.aboreto(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.brown.shade800,
        ),
      ),
    );
  }

  /// Non-editable field
  Widget _buildField(String label, String value) {
    return _fieldContainer(
      label,
      Text(
        value.isNotEmpty ? value : "-",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
    );
  }

  /// Editable field
  Widget _buildEditableField(
      String label,
      String value,
      TextEditingController controller,
      bool editable, {
        required Function(String) onChanged,
      }) {
    return _fieldContainer(
      label,
      editable
          ? TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.card,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      )
          : Text(
        value.isNotEmpty ? value : "-",
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
    );
  }

  /// Field container style
  Widget _fieldContainer(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.acme(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  /// Button builder
  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 5,
        shadowColor: Colors.black26,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      onPressed: onTap,
    );
  }
}
