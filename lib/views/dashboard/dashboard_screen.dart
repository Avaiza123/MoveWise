import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart'; // ✅ Add animation package
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_texts.dart';
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

  final List<Map<String, String>> videoData = [
    {"image": AppImages.v1, "url": "https://www.youtube.com/watch?v=FeR-4_Opt-g"},
    {"image": AppImages.v2, "url": "https://www.youtube.com/watch?v=AdqrTg_hpEQ"},
    {"image": AppImages.v3, "url": "https://www.youtube.com/watch?v=mGQ_8OWow_A"},
    {"image": AppImages.v4, "url": "https://www.youtube.com/watch?v=VwVUBL_M1pk"},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: AppText.appName,
      selectedIndex: 0,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Plan Section Header with Fade Animation
            FadeInDown(
              duration: const Duration(milliseconds: 700),
              child: Row(
                children: [
                  Image.asset(AppImages.plan, height: 50, width: 50),
                  const SizedBox(width: 6),
                  Text(
                    AppText.planSection,
                    style: GoogleFonts.alegreya(
                      color: AppColors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            // 🔹 Animated Plan Cards
            Expanded(
              flex: 3,
              child: Obx(() {
                if (planVM.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (planVM.plans.isEmpty) {
                  return Center(
                    child: Text(
                      AppText.noPlans,
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                  );
                }

                return PageView.builder(
                  controller: PageController(viewportFraction: 0.88),
                  itemCount: planVM.plans.length,
                  onPageChanged: (index) => vm.selectPlan(index),
                  itemBuilder: (context, index) {
                    final plan = planVM.plans[index];
                    return AnimatedScale(
                      scale: vm.selectedPlanIndex.value == index ? 1.0 : 0.9,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: _planCard(
                        context,
                        plan.name,
                        "assets/images/e${index + 1}.jpg",
                        index,
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 12),

            // 🔹 Workout Section Header (Slide animation)
            FadeInRight(
              duration: const Duration(milliseconds: 700),
              child: Row(
                children: [
                  Image.asset(AppImages.session, height: 50, width: 50),
                  const SizedBox(width: 10),
                  Text(
                    AppText.workoutSessions,
                    style: GoogleFonts.alegreya(
                      color: AppColors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Workout Videos with smooth entry
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoData.length,
                itemBuilder: (context, index) {
                  final video = videoData[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    duration: const Duration(milliseconds: 600),
                    child: GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(video["url"]!);
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          Get.snackbar(AppText.error, AppText.videoOpenError,
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: Container(
                        width: 260,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
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
                                fit: BoxFit.fill,
                                width: 260,
                                height: 180,
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

  // 🔹 Plan Card with Fade and Button Animation
  // 🔹 Enhanced Plan Card with Progress + Premium Fitness UI
  Widget _planCard(BuildContext context, String title, String image, int planIndex) {
    final plan = planVM.plans[planIndex];
    final currentDay = plan.currentDay;
    final totalDays = plan.days ?? 30;
    final isStarted = currentDay > 0;
    final progress = (currentDay / totalDays).clamp(0.0, 1.0);

    final List<Color> cardColors = [
      const Color(0xFFFFA726),
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFAB47BC),
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
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          height: 260, // ✅ Rectangular shape
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // 🖼️ Background Image
                Positioned.fill(
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),

                // 🌈 Glass Overlay Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),

                // 🧠 Content Row (Left Info + Right Progress)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔹 Left Info Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 🏋️‍♂️ Title on top
                            Text(
                              title,
                              style: GoogleFonts.abyssinicaSil(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 20),

                            // 📅 Day Progress Text
                            Text(
                              isStarted
                                  ? "Day $currentDay of $totalDays"
                                  : "Not Started Yet",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const Spacer(),

                            // 🎯 Action Button
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
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
                                  backgroundColor: color,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 3,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isStarted
                                          ? Icons.play_circle_fill
                                          : Icons.flag,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isStarted ? "Continue" : "Start",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔸 Right Progress Circle (larger)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, _) => Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.5),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircularProgressIndicator(
                                value: value,
                                strokeWidth: 7,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation(color),
                              ),
                            ),
                            Text(
                              "${(value * 100).toInt()}%",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
