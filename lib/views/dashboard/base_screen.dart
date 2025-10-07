import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/res/routes/route_name.dart';
import '../../services/auth_service.dart';
import '../../view_models/profile_vm.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/custom_appbar.dart';

class BaseScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final int selectedIndex;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.selectedIndex = 0,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final ProfileVM profileVM = Get.put(ProfileVM());
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
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
            title: widget.title,

            // 🔸 Streak icon commented out
            // leading: Container(
            //   margin: const EdgeInsets.only(left: 8, top: 19),
            //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: Colors.orange.shade600,
            //     borderRadius: BorderRadius.circular(20),
            //     boxShadow: const [
            //       BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 2)),
            //     ],
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Icon(Icons.local_fire_department, color: Colors.white, size: 22),
            //       const SizedBox(width: 4),
            //       Text("🔥", style: GoogleFonts.poppins(color: Colors.white)),
            //     ],
            //   ),
            // ),

            actions: uid != null ? [_buildAvatarMenu(uid)] : [],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: widget.body,
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

  /// ✅ Avatar PopupMenu
  Widget _buildAvatarMenu(String uid) {
    return Obx(() {
      final username = profileVM.name.value.isNotEmpty ? profileVM.name.value : "User";
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
          if (value == 'profile') Get.toNamed(RouteName.Me);
          if (value == 'logout') {
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
                    style: GoogleFonts.poppins(fontSize: 15, color: Colors.redAccent)),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// ✅ Sidebar Drawer with Gradient ClipPath
  Widget _buildDrawer(String uid) {
    return ClipPath(
      clipper: _CustomDrawerClipper(),
      child: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 10,
        child: Obx(() {
          final username = profileVM.name.value.isNotEmpty ? profileVM.name.value : "User";
          final avatarLetter = username[0].toUpperCase();

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8D6E63), Color(0xFF5D4037), Color(0xFF3E2723)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      avatarLetter,
                      style: GoogleFonts.almendraSc(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColorDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Welcome",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    username,
                    style: GoogleFonts.acme(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 30),
                  _drawerItem(Icons.person, "Me", () => Get.toNamed(RouteName.Me)),
                  _drawerItem(Icons.restaurant_menu, "Nutrition",
                          () => Get.toNamed(RouteName.NutritionScreen)),
                  _drawerItem(AppIcons.water, "Water Tracker",
                          () => Get.toNamed(RouteName.WaterTrackerScreen)),
                  const Spacer(),
                  const Divider(color: Colors.white38, indent: 30, endIndent: 30),
                  _drawerItem(Icons.logout, "Logout", () async {
                    await AuthService().signOut();
                    Get.offAllNamed(RouteName.LoginScreen);
                  }, color: Colors.redAccent),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String text, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white, size: 26),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          color: color ?? Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

/// 🎨 Custom Clipper for curved sidebar
class _CustomDrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 0.85, 0);
    path.quadraticBezierTo(
        size.width, size.height * 0.5, size.width * 0.85, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
