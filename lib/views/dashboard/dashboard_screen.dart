import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/res/routes/route_name.dart';
import '../../view_models/dashboard_vm.dart';
import '../../view_models/plan_vm.dart';
import '../../view_models/streak_vm.dart';
import '../../core/constants/app_images.dart';
import 'base_screen.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardVM vm = Get.put(DashboardVM());
  final PlanVM planVM = Get.put(PlanVM(), permanent: true);
  final StreakVM streakVM = Get.put(StreakVM(), permanent: true);

  DashboardScreen({super.key});

  // 🔹 Video data (image + YouTube link)
  final List<Map<String, String>> videoData = [
    {
      "image": AppImages.v1,
      "url": "https://www.youtube.com/watch?v=FeR-4_Opt-g"
    },
    {
      "image": AppImages.v2,
      "url": "https://www.youtube.com/watch?v=AdqrTg_hpEQ"
    },
    {
      "image": AppImages.v3,
      "url": "https://www.youtube.com/watch?v=mGQ_8OWow_A"
    },
    {
      "image": AppImages.v4,
      "url": "https://www.youtube.com/watch?v=VwVUBL_M1pk"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Dashboard",
      selectedIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Plan Section
            Text(
              "Plans 💪",
              style: GoogleFonts.acme(
                color: AppColors.primaryColorDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),

            Expanded(
              flex: 3,
              child: Obx(() {
                if (planVM.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (planVM.plans.isEmpty) {
                  return const Center(child: Text("No plans available yet"));
                }

                return PageView.builder(
                  controller: PageController(viewportFraction: 0.92),
                  itemCount: planVM.plans.length,
                  onPageChanged: (index) {
                    vm.selectPlan(index);
                   // streakVM.loadStreak(selectedPlanIndex: index);
                  },
                  itemBuilder: (context, index) {
                    final plan = planVM.plans[index];
                    return _planCard(
                      context,
                      plan.name,
                      "assets/images/e${index + 1}.jpg",
                      index,
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 8),

            // 🔹 YouTube Workout Inspiration Section
            Text(
              "Workout Sessions 🎥",
              style: GoogleFonts.acme(
                color: AppColors.primaryColorDark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoData.length,
                itemBuilder: (context, index) {
                  final video = videoData[index];
                  return GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(video["url"]!);
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        Get.snackbar("Error", "Could not open video",
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              video["image"]!,
                              fit: BoxFit.cover,
                              width: 300,
                              height: 200,
                            ),
                            Container(
                              color: Colors.black26,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Plan Card Widget
  Widget _planCard(
      BuildContext context,
      String title,
      String image,
      int planIndex,
      ) {
    final plan = planVM.plans[planIndex];
    final currentDay = plan.currentDay;
    final isStarted = currentDay > 0;

    // 🔸 Themed card colors
    final List<Color> cardColors = [
      const Color(0xFFD2A56E),
      const Color(0xFFB87333),
      const Color(0xFF9E6C55),
      const Color(0xFFB85B16),
      const Color(0xFFF4B860),
    ];

    final color = cardColors[planIndex % cardColors.length];

    return GestureDetector(
      onTap: () {
        if (isStarted) {
          Get.toNamed(RouteName.PlanScreen, arguments: {
            'planIndex': planIndex,
            'day': currentDay,
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // 🔹 Background Image
            Image.asset(
              image,
              width: double.infinity,
              height: 245,
              fit: BoxFit.fill,
            ),

            // 🔹 Gradient Overlay (stronger opacity for depth)
            Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),

            // 🔹 Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isStarted ? "Day $currentDay" : "Not Started Yet",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 75),
                  ElevatedButton(
                    onPressed: () {
                      if (!isStarted) {
                        planVM.startPlan(planIndex);
                      } else {
                        Get.toNamed(RouteName.PlanScreen, arguments: {
                          'planIndex': planIndex,
                          'day': currentDay,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.withOpacity(0.95),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      isStarted ? "Continue" : "Start",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
