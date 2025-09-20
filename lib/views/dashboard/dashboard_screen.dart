import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/res/routes/route_name.dart';
import '../../services/auth_service.dart';
import '../../view_models/profile_vm.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/bottom_navbar.dart';
import '../../models/exercise_model.dart';
import '../../view_models/exercise_vm.dart';
import '../chatbot/chatbot_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExerciseViewModel viewModel = ExerciseViewModel();
  final ProfileVM profileVM = Get.put(ProfileVM());

  List<Exercise> userPlan = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadPlan();
  }

  Future<void> loadPlan() async {
    await viewModel.loadExercises();
    final exercises = await viewModel.getExercisesForCachedBmi();
    setState(() => userPlan = exercises);
  }

  void _onNavBarTap(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) Get.toNamed(RouteName.ProfileScreen);
    if (index == 1) Get.toNamed(RouteName.NutritionScreen);
    if (index == 2) Get.toNamed(RouteName.WaterTrackerScreen);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      drawer: uid != null ? _buildDrawer(uid) : null,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomAppBar(
          title: "Dashboard",
          actions: uid != null ? [_buildPopupMenu(uid)] : [],
        ),
      ),
      body: userPlan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: userPlan.length,
        itemBuilder: (context, index) {
          final exercise = userPlan[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  exercise.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                exercise.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => ChatBotScreen()),
        backgroundColor: AppColors.primaryColorDark,
        child: const Icon(AppIcons.chatbot, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildPopupMenu(String uid) {
    return Obx(() {
      final username = profileVM.name.value.isNotEmpty
          ? profileVM.name.value
          : "User";
      final avatarLetter = username[0].toUpperCase();

        return PopupMenuButton<String>(
          icon: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: Text(
              avatarLetter,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          offset: const Offset(0, 50), // Moves menu downward relative to avatar
          onSelected: (value) async {
            if (value == 'profile') Get.toNamed(RouteName.ProfileScreen);
            else if (value == 'logout') {
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
                  Text("Profile", style: GoogleFonts.poppins(fontSize: 15)),
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

      },
    );
  }

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
          final username = profileVM.name.value.isNotEmpty
              ? profileVM.name.value
              : "User";
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
                            style: GoogleFonts.acme(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade800,
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
                                    fontSize: 14, color: Colors.white70),
                              ),
                              Text(
                                username,
                                style: GoogleFonts.acme(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
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
                          text: "Profile",
                          onTap: () => Get.toNamed(RouteName.ProfileScreen),
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
                        const Divider(color: Colors.white38, indent: 20, endIndent: 20),
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
          },
        ),
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
