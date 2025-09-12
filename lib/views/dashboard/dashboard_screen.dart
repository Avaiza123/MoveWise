import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_icons.dart';
import 'package:movewise/core/res/routes/routes.dart';
import '../../models/exercise_model.dart';
import '../../services/auth_service.dart';
import '../../view_models/exercise_vm.dart';
import '../../widgets/custom_appbar.dart';
import '../chatbot/chatbot_screen.dart';
import '../../core/res/routes/route_name.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExerciseViewModel viewModel = ExerciseViewModel();
  List<Exercise> userPlan = [];

  @override
  void initState() {
    super.initState();
    loadPlan();
  }

  Future<void> loadPlan() async {
    await viewModel.loadExercises();
    final exercises = await viewModel.getExercisesForCachedBmi();
    setState(() {
      userPlan = exercises;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomAppBar(
          title: "Dashboard",
          actions: [
            _buildAvatarMenu(context, "user@email.com"), // 👈 Replace with cached user email
          ],
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
              borderRadius: BorderRadius.circular(12),
            ),
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

      /// 👇 Floating Chatbot Icon
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() =>  ChatBotScreen());
        },
        backgroundColor: AppColors.primaryColorDark,
        child: const Icon(AppIcons.chatbot, color: Colors.white),
      ),
    );
  }

  /// Sidebar Drawer
  Widget _buildDrawer(BuildContext context) {
    return SizedBox(
      width: 270, // 👈 set custom width
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColorDark),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text(
                      "U", // 👈 Replace with first letter of email
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Welcome User",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Get.toNamed(RouteName.ProfileScreen);
              },
            ),
            ListTile(
              leading: const Icon(Icons.food_bank_outlined),
              title: const Text("Nutrition"),
              onTap: () {
                Get.toNamed(RouteName.NutritionScreen);
              },
            ),

            /// 🚰 Water Retention Screen Route
            ListTile(
              leading: const Icon(AppIcons.water),
              title: const Text("Water Retention"),
              onTap: () {
                Get.toNamed(RouteName.WaterTrackerScreen);
              },
            ),


            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                try {
                  await AuthService().signOut();
                  Get.offAllNamed(RouteName.LoginScreen);
                } catch (e) {
                  Get.snackbar("Logout Failed", e.toString(),
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  /// Avatar Menu in AppBar
  Widget _buildAvatarMenu(BuildContext context, String email) {
    final String letter = email.isNotEmpty ? email[0].toUpperCase() : "?";

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        if (value == 'profile') {
          Get.toNamed(RouteName.ProfileScreen);
        } else if (value == 'logout') {
          try {
            await AuthService().signOut();
            Get.offAllNamed(RouteName.LoginScreen);
          } catch (e) {
            Get.snackbar("Logout Failed", e.toString(),
                snackPosition: SnackPosition.BOTTOM);
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: ListTile(
            leading: Icon(AppIcons.profile),
            title: Text("Profile"),
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: ListTile(
            leading: Icon(AppIcons.settings),
            title: Text("Settings"),
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(AppIcons.logout),
            title: Text("Logout"),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade200,
          child: Text(
            letter,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
