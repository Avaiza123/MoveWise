import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewise/core/constants/app_sizes.dart';
import '../../../view_models/nutrition_vm.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../widgets/custom_appbar.dart';

class NutritionScreen extends StatelessWidget {
  NutritionScreen({super.key});

  final NutritionVM vm = Get.put(NutritionVM());
  final TextEditingController queryController = TextEditingController();

  final List<Color> bgColors = const [
    AppColors.lavender,
    AppColors.yellow,
    AppColors.mint,
    AppColors.pink,
    AppColors.peach,
    AppColors.sky,
    AppColors.gray,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppBar(title: AppText.nutritionCounter, actions: const []),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: queryController,
              decoration: InputDecoration(
                hintText: AppText.searchFoodHint,
                prefixIcon: const Icon(AppIcons.search),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  vm.getNutrition(value);
                }
              },
            ),
            const SizedBox(height: AppSizes.s16),

            // Expanded body
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
                  children: [
                    // ---- Search Results ----
                    if (vm.nutritionList.isNotEmpty) ...[
                      Text(
                        AppText.searchResults,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...vm.nutritionList.asMap().entries.map((entry) {
                        final item = entry.value;

                        return Stack(
                          children: [
                            Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
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
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildNutritionRow(AppIcons.calories,
                                        AppText.calories, "${item.calories} kcal"),
                                    _buildNutritionRow(AppIcons.protein,
                                        AppText.protein, "${item.protein} g"),
                                    _buildNutritionRow(AppIcons.fat,
                                        AppText.fat, "${item.fat} g"),
                                    _buildNutritionRow(AppIcons.carbs,
                                        AppText.carbs, "${item.carbohydrates} g"),
                                    _buildNutritionRow(AppIcons.sugar,
                                        AppText.sugar, "${item.sugar} g"),
                                    _buildNutritionRow(AppIcons.fiber,
                                        AppText.fiber, "${item.fiber} g"),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 192,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: IconButton(
                                  icon: const Icon(
                                    AppIcons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    vm.addFood(item);
                                    Get.snackbar(
                                      AppText.addedSnackTitle,
                                      "${item.name} ${AppText.addedSnackMsg}",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.grey.withOpacity(0.3),
                                      colorText: AppColors.textPrimary,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                    ],

                    // ---- Daily Picks ----
                    if (vm.addedList.isNotEmpty) ...[
                      Text(
                        AppText.dailyPicks,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...vm.addedList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final bgColor = bgColors[index % bgColors.length];

                        return Card(
                          color: bgColor.withOpacity(0.6),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              AppIcons.food,
                              color: AppColors.textPrimary,
                              size: 28,
                            ),
                            title: Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
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
                                  _macroChip(AppIcons.protein,
                                      "P: ${item.protein}g"),
                                  _macroChip(AppIcons.fat,
                                      "F: ${item.fat}g"),
                                  _macroChip(AppIcons.carbs,
                                      "C: ${item.carbohydrates}g"),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                AppIcons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                vm.removeFood(index);
                                Get.snackbar(
                                  AppText.deletedSnackTitle,
                                  "${item.name} ${AppText.deletedSnackMsg}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  colorText: AppColors.textPrimary,
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ],

                    if (vm.nutritionList.isEmpty && vm.addedList.isEmpty)
                      Center(
                        child: Text(
                          AppText.noData,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),

      // Floating Add Button (bottom-right)
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.primary,
      //   child: const Icon(AppIcons.add, color: Colors.white),
      //   onPressed: () {
      //     if (queryController.text.isNotEmpty) {
      //       vm.getNutrition(queryController.text);
      //     } else {
      //       Get.snackbar(
      //         AppText.error,
      //         AppText.error,
      //         snackPosition: SnackPosition.BOTTOM,
      //         backgroundColor: Colors.red.shade100,
      //         colorText: AppColors.textPrimary,
      //       );
      //     }
      //   },
      // ),
    );
  }

  Widget _buildNutritionRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 3),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
