import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movewise/core/res/routes/route_name.dart';
import '../../core/constants/app_colors.dart';
import '../../view_models/dashboard_vm.dart';
import '../../view_models/plan_vm.dart';
import '../../widgets/day_box.dart';
import 'base_screen.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardVM vm = Get.put(DashboardVM());
  final PlanVM planVM = Get.put(PlanVM(), permanent: true);

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Dashboard",
      selectedIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with fitness icon
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Icon(Icons.fitness_center,
                      size: 72, color: AppColors.primaryColorDark),
                  const SizedBox(height: 8),
                  Text(
                    "Keep going! Complete today's exercises",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 30-day horizontal calendar
            Text(
              "30-day challenge",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Obx(() {
              final highest = vm.highestCompletedDay.value;
              return SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    final dayNum = index + 1;
                    return DayBox(
                      dayNumber: dayNum,
                      completed: dayNum <= highest,
                      onTap: () {
                        Get.snackbar(
                          "Day",
                          "Day $dayNum selected",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 20),

            // Plan cards
            Expanded(
              child: Obx(() {
                if (planVM.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Dynamically map plans with fallback titles/images
                final List<Map<String, String>> planData = List.generate(
                  4,
                      (i) => {
                    "title": i < planVM.plans.length
                        ? planVM.plans[i].name
                        : "Plan ${i + 1}",
                    "image": "assets/images/e${i + 1}.jpg",
                  },
                );

                return ListView.builder(
                  itemCount: planData.length,
                  itemBuilder: (context, index) {
                    final data = planData[index];
                    final hasPlan = index < planVM.plans.length;
                    return _planCard(
                        context, data['title']!, data['image']!, hasPlan ? index : -1);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard(BuildContext context, String title, String image, int planIndex) {
    return GestureDetector(
      onTap: () {
        if (planIndex >= 0 && planIndex < planVM.plans.length) {
          Get.toNamed(RouteName.PlanScreen, arguments: {'planIndex': planIndex});
        } else {
          Get.snackbar(
            "Plan not ready",
            "This plan is still loading.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(image, width: 86, height: 86, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
