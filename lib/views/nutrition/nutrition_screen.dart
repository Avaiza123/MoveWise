import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewise/core/constants/app_images.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import 'package:movewise/core/constants/app_colors.dart';
import '../../../view_models/nutrition_vm.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../widgets/custom_appbar.dart';

class NutritionScreen extends StatelessWidget {
  NutritionScreen({super.key});

  final NutritionVM vm = Get.put(NutritionVM());
  final TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppBar(
          title: AppText.nutritionCounter,
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          // 🔹 Background image
          Image.asset(
            AppImages.nutrition,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.45)),

          // Page content
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 80, // appbar height + safe area
              16,
              16,
            ),
            child: Column(
              children: [
                // 🔹 Top Counter
                Obx(() => Text(
                  "${vm.totalCalories.value} / ${vm.dailyCalorieLimit} kcal",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
                const SizedBox(height: AppSizes.s24),

                // 🔹 Circular Bowl with Fill
                Obx(() {
                  return SizedBox(
                    height: 220,
                    width: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular fill animation
                        ClipOval(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: vm.calorieProgress,
                              child: Container(
                                color: _progressColor(vm.calorieProgress),
                              ),
                            ),
                          ),
                        ),

                        // Bowl image overlay
                        Image.asset(
                          AppImages.diet,
                          fit: BoxFit.contain,
                          width: 200,
                          height: 200,
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSizes.s20),

                // 🔹 Search Bar
                TextField(
                  controller: queryController,
                  style: GoogleFonts.poppins(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: AppText.searchFoodHint,
                    hintStyle: GoogleFonts.poppins(color: Colors.white),
                    prefixIcon:
                    Icon(AppIcons.search, color: AppColors.primaryColorDark),
                    filled: true,
                    fillColor: AppColors.primaryColor.withOpacity(0.7), // more opacity
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      vm.getNutrition(value);
                    }
                  },
                ),

                // 🔹 Expanded Body
                Expanded(
                  child: Obx(() {
                    if (vm.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (vm.error.value.isNotEmpty) {
                      return Center(
                        child: Text(
                          vm.error.value,
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.only(top: 16), // 👈 keeps results snug

                      children: [
                        // ---- Search Results ----
                        if (vm.nutritionList.isNotEmpty) ...[
                          Text(
                            AppText.searchResults,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                         // const SizedBox(height: 8),
                          ...vm.nutritionList.map((item) {
                            return Card(
                              color: Colors.white.withOpacity(0.7),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name.isNotEmpty
                                          ? item.name[0].toUpperCase() +
                                          item.name.substring(1)
                                          : AppText.nutrition,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildNutritionRow(AppIcons.calories,
                                        AppText.calories, "${item.calories} cal"),
                                    // _buildNutritionRow(AppIcons.protein,
                                    //     AppText.protein, "${item.protein} g"),
                                    _buildNutritionRow(AppIcons.fat,
                                        AppText.fat, "${item.fat} g"),
                                    _buildNutritionRow(AppIcons.carbs,
                                        AppText.carbs, "${item.carbohydrates} g"),
                                    _buildNutritionRow(AppIcons.sugar,
                                        AppText.sugar, "${item.sugar} g"),
                                    _buildNutritionRow(AppIcons.fiber,
                                        AppText.fiber, "${item.fiber} g"),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryColorDark,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                          ),
                                        ),
                                        icon: const Icon(AppIcons.add),
                                        label: Text("Add",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600)),
                                        onPressed: () {
                                          vm.addFood(item);
                                          Get.snackbar(
                                            AppText.addedSnackTitle,
                                            "${item.name} ${AppText.addedSnackMsg}",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: AppColors.primaryColor.withOpacity(0.7),
                                            colorText: AppColors.black,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                        ],

                        // ---- Daily Picks ----
                        if (vm.addedList.isNotEmpty) ...[
                          Text(
                            AppText.dailyPicks,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...vm.addedList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;

                            return Card(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(46),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  AppIcons.food,
                                  color: AppColors.primaryColorDark,
                                  size: 28,
                                ),
                                title: Text(
                                  item.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      _macroChip(AppIcons.calories,
                                          "${item.calories} kcal"),
                                      // _macroChip(AppIcons.protein,
                                      //     "P: ${item.protein}g"),
                                      _macroChip(AppIcons.fat,
                                          "F: ${item.fat}g"),
                                      _macroChip(AppIcons.carbs,
                                          "C: ${item.carbohydrates}g"),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(AppIcons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    vm.removeFood(index);
                                    Get.snackbar(
                                      AppText.deletedSnackTitle,
                                      "${item.name} ${AppText.deletedSnackMsg}",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColors.primaryColor.withOpacity(0.6),
                                      colorText: AppColors.black,
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                        ],

                        // 🔹 No gap if nothing
                        if (vm.nutritionList.isEmpty &&
                            vm.addedList.isEmpty) ...[
                          const SizedBox(height: AppSizes.s20),
                          Center(
                            child: Text(
                              AppText.noData,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.brown[400],
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Nutrition Row
  Widget _buildNutritionRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.brown[900]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.brown[800],
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Macro Chip
  Widget _macroChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.brown[900]),
          const SizedBox(width: 3),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.brown[600],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Fill color logic
  Color _progressColor(double progress) {
    if (progress < 0.6) return Colors.green.withOpacity(0.8);
    if (progress < 0.9) return Colors.orange.withOpacity(0.7);
    return Colors.red.withOpacity(0.7);
  }
}
