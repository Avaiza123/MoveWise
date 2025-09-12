import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../view_models/water_vm.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/constants/app_icons.dart';
import '../../widgets/custom_appbar.dart';

class WaterTrackerScreen extends StatelessWidget {
  WaterTrackerScreen({super.key});

  final WaterTrackerViewModel vm = Get.put(WaterTrackerViewModel());

  final List<Map<String, dynamic>> drinkOptions = [
    {"type": "Water", "amount": 250, "icon": AppIcons.water},
    {"type": "Juice", "amount": 200, "icon": AppIcons.juice},
    {"type": "Tea", "amount": 150, "icon": AppIcons.tea},
    {"type": "Coffee", "amount": 150, "icon": AppIcons.coffee},
  ];

  final Map<String, Color> cardColors = {
    "Water": AppColors.lilac.withOpacity(0.65),
    "Juice": AppColors.pink.withOpacity(0.65),
    "Tea": AppColors.peach.withOpacity(0.65),
    "Coffee": AppColors.yellow.withOpacity(0.65),
  };

  IconData _getIconForType(String type) {
    final match = drinkOptions.firstWhere(
          (d) => d["type"] == type,
      orElse: () => {"icon": AppIcons.water},
    );
    return match["icon"];
  }

  Color _getColorForType(String type) {
    return cardColors[type] ?? AppColors.gray;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender.withOpacity(0.6), // lightest bg
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomAppBar(
          title: AppText.waterTracker,
          actions: const [],
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bigger Progress Circle
              SizedBox(
                height: 350,
                width: 350,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: vm.progress.clamp(0, 1),
                      strokeWidth: 200,
                      backgroundColor: AppColors.gray.withOpacity(0.8),
                      color: Colors.green, // green progress
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(vm.totalIntake / 1000).toStringAsFixed(1)} / ${(vm.dailyGoal / 1000).toStringAsFixed(1)} L",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 260),
                        Text(
                          "Daily Hydration",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Drink Buttons (2 per row)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Quick Add",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 3.2, // control width/height of buttons
                children: drinkOptions.map((drink) {
                  return ElevatedButton.icon(
                    onPressed: () =>
                        vm.addEntry(drink["type"], drink["amount"]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.card,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    icon: Icon(drink["icon"],
                        color: AppColors.primary, size: 22),
                    label: Text(
                      "${drink["type"]} (${(drink["amount"] / 1000).toStringAsFixed(2)} L)",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Entries List
              vm.entries.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "No drinks logged yet",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.entries.length,
                itemBuilder: (context, index) {
                  final entry = vm.entries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    color: _getColorForType(entry.type),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        AppColors.primary.withOpacity(0.1),
                        child: Icon(
                          _getIconForType(entry.type),
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        "${entry.type} - ${(entry.amount / 1000).toStringAsFixed(2)} L",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          vm.deleteEntry(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
