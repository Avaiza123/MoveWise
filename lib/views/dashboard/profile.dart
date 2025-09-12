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
 // final vm = Get.put(ProfileVM());


  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Obx(() {
          return CustomAppBar(
            title: AppText.profile,
            actions: [
              vm.isEditing.value
                  ? IconButton(
                icon: const Icon(AppIcons.cancel, color: Colors.white),
                onPressed: () => vm.cancelEdit(),
              )
                  : IconButton(
                icon: const Icon(AppIcons.edit, color: Colors.white),
                onPressed: () {
                  nameController.text = vm.name.value;
                  weightController.text = vm.weight.value;
                  heightController.text = vm.height.value;
                  vm.enableEdit();
                },
              ),
            ],
          );
        }),
      ),
      body: Obx(() {
        if (vm.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Email (non-editable)
              _buildField(AppText.email, vm.email.value),

              const SizedBox(height: 16),

              // Name
              _buildEditableField(
                AppText.nameLabel,
                vm.name.value,
                nameController,
                vm.isEditing.value,
                onChanged: (v) => vm.name.value = v,
              ),

              const SizedBox(height: 16),

              // Weight
              _buildEditableField(
                AppText.weightLabel,
                vm.weight.value,
                weightController,
                vm.isEditing.value,
                onChanged: (v) => vm.weight.value = v,
              ),

              const SizedBox(height: 16),

              // Height + Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildEditableField(
                      AppText.height,
                      vm.height.value,
                      heightController,
                      vm.isEditing.value,
                      onChanged: (v) => vm.height.value = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: vm.isEditing.value
                        ? DropdownButtonFormField<String>(
                      value: vm.heightUnit.value,
                      items: const [
                        DropdownMenuItem(
                            value: "cm", child: Text("cm")),
                        DropdownMenuItem(
                            value: "ft", child: Text("ft")),
                        DropdownMenuItem(
                            value: "in", child: Text("in")),
                      ],
                      onChanged: (val) {
                        if (val != null) vm.heightUnit.value = val;
                      },
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
                        vm.heightUnit.value,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // BMI (retrieved from cache/Firestore, no calculation)
              _buildField(AppText.bmiLabel, vm.bmi.value),

              const SizedBox(height: 24),

              if (vm.isEditing.value)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(AppIcons.save, color: Colors.white),
                  label: Text(
                    AppText.saveChanges,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => vm.saveProfile(),
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
      ],
    );
  }

  Widget _buildEditableField(
      String label,
      String value,
      TextEditingController controller,
      bool editable, {
        required Function(String) onChanged,
      }) {
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
      ],
    );
  }
}
