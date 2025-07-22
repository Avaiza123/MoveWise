import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? selectedGender;

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void _navigateNext() {
    if (selectedGender != null) {
      Navigator.pushNamed(context, '/goal');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Please select your gender.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.buttonColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildGenderCard({
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedGender == label;

    return GestureDetector(
      onTap: () => _selectGender(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppColors.primaryColorDark : Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryColorDark : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
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
            'Select Gender',
            style: AppStyles.appBarTitle,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(14),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Who are you?', style: AppStyles.screenTitle),
            const SizedBox(height: 20),
            Text(
              'Let us know your gender to personalize your experience.',
              style: TextStyle(fontSize: 16, color: AppColors.textSubtleColor),
            ),
            const SizedBox(height: 40),

            _buildGenderCard(label: 'Male', icon: Icons.male),
            _buildGenderCard(label: 'Female', icon: Icons.female),
            _buildGenderCard(label: 'Prefer not to say', icon: Icons.help_outline_rounded),

            const SizedBox(height: 35),

            Center(
              child: ElevatedButton(
                onPressed: _navigateNext,
                style: AppStyles.elevatedButtonStyle,
                child: Text('Next', style: AppStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
