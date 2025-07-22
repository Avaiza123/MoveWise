import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final Set<String> selectedGoals = {};

  final List<String> goals = [
    'Lose Weight',
    'Build Muscle',
    'Stay Fit',
    'Increase Flexibility',
    'Improve Posture',
  ];

  void _navigateNext() {
    if (selectedGoals.isNotEmpty) {
      Navigator.pushNamed(context, '/height');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.buttonColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Text(
            'Please select at least one goal to continue',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        selectedGoals.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppColors.appBarColor,
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.3),
          centerTitle: true,
          title: Text(
            'Select Your Goal',
            style: AppStyles.appBarTitle,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What are your fitness goals?', style: AppStyles.screenTitle),
            const SizedBox(height: 30),

            // Goals List
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  final isSelected = selectedGoals.contains(goal);

                  return GestureDetector(
                    onTap: () => _toggleGoal(goal),
                    child: Card(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(0.9)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryColorDark
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color:
                              isSelected ? Colors.white : Colors.grey[600],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                goal,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                ),
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

            const SizedBox(height: 10),

            Center(
              child: ElevatedButton(
                onPressed: _navigateNext,
                style: AppStyles.elevatedButtonStyle,
                child: Text('Continue', style: AppStyles.buttonText),
              ),
            ),

            const SizedBox(height: 220),
          ],
        ),
      ),
    );
  }
}
