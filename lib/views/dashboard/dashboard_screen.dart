import 'package:flutter/material.dart';
import 'package:movewise/core/constants/app_colors.dart';
import 'package:movewise/core/utils/app_styles.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.customAppBar('Dashboard'),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back!', style: AppStyles.screenTitle),
            const SizedBox(height: 20),

            // Cards Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () {
                    // Navigate or handle tap
                  },
                ),
                _buildDashboardCard(
                  icon: Icons.fitness_center,
                  label: 'Workout',
                  onTap: () {
                    // Navigate or handle tap
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard(
                  icon: Icons.bar_chart,
                  label: 'Progress',
                  onTap: () {
                    // Navigate or handle tap
                  },
                ),
                _buildDashboardCard(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    // Navigate or handle tap
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 140,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.primaryColor),
              const SizedBox(height: 12),
              Text(label, style: AppStyles.cardText),
            ],
          ),
        ),
      ),
    );
  }
}
