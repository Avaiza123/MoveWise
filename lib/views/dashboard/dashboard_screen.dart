import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/res/routes/route_name.dart';
import '../../services/auth_service.dart';
import '../../view_models/exercise_vm.dart';
import '../../view_models/profile_vm.dart';
import '../../models/exercise_model.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/bottom_navbar.dart';
import '../exercise/exercise_plan_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExerciseViewModel viewModel = Get.put(ExerciseViewModel());
  final ProfileVM profileVM = Get.put(ProfileVM());

  final Map<String, String> bmiFileMap = {
    "Severely Underweight": "assets/json/Severely_Underweight.json",
    "Moderately Underweight": "assets/json/Moderately_Underweight.json",
    "Mild Thinness": "assets/json/Mild_Thinness.json",
    "Normal": "assets/json/Normal.json",
    "Overweight": "assets/json/Overweight.json",
    "Obese Class I": "assets/json/Obese_1.json",
    "Obese Class II": "assets/json/Obese_2.json",
    "Obese Class III": "assets/json/Obese_3.json",
  };

  static const yogaPlan = "assets/json/yoga_30_days_plan.json";

  Map<String, List<Exercise>> userPlans = {
    "Easier Plan": [],
    "Your Plan": [],
    "Harder Plan": [],
    "Yoga Plan": [],
  };

  // Plan cover images
  final Map<String, String> planCovers = {
    "Easier Plan": "assets/images/e1.jpg",
    "Your Plan": "assets/images/e2.jpg",
    "Harder Plan": "assets/images/e3.jpg",
    "Yoga Plan": "assets/images/yoga_title.jpg",
  };

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    // 🔹 Correct: get bmi from profile map
    final data = doc.data();
    final double bmi = (data?['profile']?['bmi'] ?? 0).toDouble();

    final String category = _bmiCategory(bmi);
    final categories = bmiFileMap.keys.toList();
    final currentIndex = categories.indexOf(category);

    List<String> selectedPaths = [];

    if (currentIndex == 0) {
      selectedPaths = [
        bmiFileMap[categories[currentIndex]]!,
        bmiFileMap[categories[currentIndex + 1]]!,
        bmiFileMap[categories[currentIndex + 2]]!,
      ];
    } else if (currentIndex == categories.length - 1) {
      selectedPaths = [
        bmiFileMap[categories[currentIndex - 2]]!,
        bmiFileMap[categories[currentIndex - 1]]!,
        bmiFileMap[categories[currentIndex]]!,
      ];
    } else {
      selectedPaths = [
        bmiFileMap[categories[currentIndex - 1]]!,
        bmiFileMap[categories[currentIndex]]!,
        bmiFileMap[categories[currentIndex + 1]]!,
      ];
    }

    final easierPlan = await viewModel.loadExercisesFromJson(selectedPaths[0]);
    final yourPlan = await viewModel.loadExercisesFromJson(selectedPaths[1]);
    final harderPlan = await viewModel.loadExercisesFromJson(selectedPaths[2]);
    final yogaExercises = await viewModel.loadExercisesFromJson(yogaPlan);

    setState(() {
      userPlans = {
        "Easier Plan": easierPlan,
        "Your Plan": yourPlan,
        "Harder Plan": harderPlan,
        "Yoga Plan": yogaExercises,
      };
    });
  }


  String _bmiCategory(double bmi) {
    if (bmi < 16) return "Severely Underweight";
    if (bmi < 17) return "Moderately Underweight";
    if (bmi < 18.5) return "Mild Thinness";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    if (bmi < 35) return "Obese Class I";
    if (bmi < 40) return "Obese Class II";
    return "Obese Class III";
  }

  void _onNavBarTap(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) Get.toNamed(RouteName.Me);
    if (index == 1) Get.toNamed(RouteName.NutritionScreen);
    if (index == 2) Get.toNamed(RouteName.WaterTrackerScreen);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFBE9E7), Color(0xFFD7CCC8), Color(0xFFEFEBE9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: uid != null ? _buildDrawer(uid) : null,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: CustomAppBar(
            title: "Dashboard",
            actions: uid != null ? [_buildPopupMenu(uid)] : [],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: ListView(
            children: userPlans.entries.map((entry) {
              return _buildPlanCard(
                title: entry.key,
                imagePath: planCovers[entry.key] ?? "assets/images/e1.png",
                exercises: entry.value,
              );
            }).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(RouteName.ChatBotScreen),
          backgroundColor: AppColors.primaryColorDark,
          child: const Icon(AppIcons.chatbot, color: Colors.white),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onNavBarTap,
        ),
      ),
    );
  }

  /// Build plan card with image and button
  Widget _buildPlanCard({
    required String title,
    required String imagePath,
    required List<Exercise> exercises,
  }) {
    return GestureDetector(
      onTap: () {
        print("Plan: $title, Exercises count: ${exercises.length}");
        if (exercises.isNotEmpty) {
          Get.to(() => ExercisePlanScreen(title: title, exercises: exercises));
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: Text(
                title,
                style: GoogleFonts.merriweatherSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColorDark,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (exercises.isNotEmpty) {
                    Get.to(() =>
                        ExercisePlanScreen(title: title, exercises: exercises));
                  }
                },
                child: Text(
                  "View Plan",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Popup menu on AppBar
  Widget _buildPopupMenu(String uid) {
    return Obx(() {
      final username =
      profileVM.name.value.isNotEmpty ? profileVM.name.value : "User";
      final avatarLetter = username[0].toUpperCase();

      return PopupMenuButton<String>(
        icon: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade200,
          child: Text(
            avatarLetter,
            style: GoogleFonts.almendraSc(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColorDark,
            ),
          ),
        ),
        offset: const Offset(0, 50),
        onSelected: (value) async {
          if (value == 'profile') {
            Get.toNamed(RouteName.Me);
          } else if (value == 'logout') {
            await AuthService().signOut();
            Get.offAllNamed(RouteName.LoginScreen);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.brown),
                const SizedBox(width: 8),
                Text("Me", style: GoogleFonts.poppins(fontSize: 15)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                const Icon(Icons.logout, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text("Logout",
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: Colors.redAccent)),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Drawer with navigation items
  Widget _buildDrawer(String uid) {
    return SizedBox(
      width: 280,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 10,
        child: Obx(() {
          final username =
          profileVM.name.value.isNotEmpty ? profileVM.name.value : "User";
          final avatarLetter = username[0].toUpperCase();

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColorDark,
                  Colors.brown.shade300,
                  Colors.brown.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                DrawerHeader(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          avatarLetter,
                          style: GoogleFonts.almendraSc(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColorDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.white70),
                            ),
                            Text(
                              username,
                              style: GoogleFonts.acme(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _drawerItem(
                        icon: Icons.person,
                        text: "Me",
                        onTap: () => Get.toNamed(RouteName.Me),
                      ),
                      _drawerItem(
                        icon: Icons.food_bank_outlined,
                        text: "Nutrition",
                        onTap: () => Get.toNamed(RouteName.NutritionScreen),
                      ),
                      _drawerItem(
                        icon: AppIcons.water,
                        text: "Water Tracker",
                        onTap: () => Get.toNamed(RouteName.WaterTrackerScreen),
                      ),
                      const Divider(
                          color: Colors.white38, indent: 20, endIndent: 20),
                      _drawerItem(
                        icon: Icons.logout,
                        text: "Logout",
                        color: Colors.redAccent,
                        onTap: () async {
                          await AuthService().signOut();
                          Get.offAllNamed(RouteName.LoginScreen);
                        },
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

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white, size: 26),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}
