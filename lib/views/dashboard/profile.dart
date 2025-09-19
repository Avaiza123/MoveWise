import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view_models/profile_vm.dart';
import '../../core/constants/app_colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: CustomAppBar(title: AppText.profile),
      ),
      body: Obx(() {
        if (vm.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField("Email", vm.email.value),
              const SizedBox(height: 16),

              _buildEditableField(
                "Name",
                vm.name.value,
                nameController,
                vm.isEditing.value,
                onChanged: (v) => vm.name.value = v,
              ),
              const SizedBox(height: 16),

              _buildEditableField(
                "Weight",
                vm.weight.value,
                weightController,
                vm.isEditing.value,
                onChanged: (v) => vm.weight.value = v,
              ),
              const SizedBox(height: 6),
              _buildField("Weight Unit", vm.weightUnit.value),
              const SizedBox(height: 16),

              _buildEditableField(
                "Height",
                vm.height.value,
                heightController,
                vm.isEditing.value,
                onChanged: (v) => vm.height.value = v,
              ),
              const SizedBox(height: 6),
              _buildField("Height Unit", vm.heightUnit.value),
              const SizedBox(height: 16),

              _buildField("BMI", vm.bmi.value),
              const SizedBox(height: 16),

              _buildField("Gender", vm.gender.value),
              const SizedBox(height: 16),

              _buildField(
                "Goals",
                vm.goals.isNotEmpty ? vm.goals.join(", ") : "-",
              ),
              const SizedBox(height: 16),

              _buildField(
                "Diet Preferences",
                vm.dietPreferences.isNotEmpty
                    ? vm.dietPreferences.join(", ")
                    : "-",
              ),
              const SizedBox(height: 32),

              // 👇 Edit / Save & Cancel buttons
              vm.isEditing.value
                  ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(AppIcons.cancel, color: Colors.white),
                      label: Text("Cancel",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      onPressed: () {
                        // Revert changes
                        nameController.text = vm.name.value;
                        weightController.text = vm.weight.value;
                        heightController.text = vm.height.value;
                        vm.isEditing.value = false;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(AppIcons.save, color: Colors.white),
                      label: Text("Save",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      onPressed: () => vm.saveProfile(),
                    ),
                  ),
                ],
              )
                  : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(AppIcons.edit, color: Colors.white),
                label: Text("Edit Profile",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                onPressed: () {
                  nameController.text = vm.name.value;
                  weightController.text = vm.weight.value;
                  heightController.text = vm.height.value;
                  vm.enableEdit();
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.isNotEmpty ? value : "-",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEditableField(String label, String value,
      TextEditingController controller, bool editable,
      {required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        editable
            ? TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.poppins(fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        )
            : Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.isNotEmpty ? value : "-",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
