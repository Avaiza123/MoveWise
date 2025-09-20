import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/constants/app_icons.dart';
import '../core/res/routes/route_name.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90, // increased height to avoid overflow
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: AppIcons.water,
            label: 'Water',
            index: 0,
            selected: selectedIndex == 0,
            onTap: () {
              onTap(0);
              Get.offNamed(RouteName.WaterTrackerScreen);
            },
          ),
          _navItem(
            icon: AppIcons.food,
            label: 'Nutrition',
            index: 1,
            selected: selectedIndex == 1,
            onTap: () {
              onTap(1);
              Get.offNamed(RouteName.NutritionScreen);
            },
          ),
          _navItem(
            icon: AppIcons.profile,
            label: 'Profile',
            index: 2,
            selected: selectedIndex == 2,
            onTap: () {
              onTap(2);
              Get.offNamed(RouteName.ProfileScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected
                  ? const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              color: selected ? null : Colors.grey.shade400, // grey circle
              boxShadow: selected
                  ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
                  : [],
            ),
            child: Icon(
              icon,
              size: selected ? 28 : 24,
              color: selected ? Colors.white : Colors.grey.shade700, // grey icon
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white, // text always white
            ),
          ),
        ],
      ),
    );
  }
}
