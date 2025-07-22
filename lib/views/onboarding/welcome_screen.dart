import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart'; // Adjust this import based on your directory
import '../../../utils/app_colors.dart'; // Adjust as needed

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateNext() {
    Navigator.pushNamed(context, '/gender');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Content
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Image
                    Container(
                      width: 650,
                      height: 650,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/images/logo2.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Get Started Button using central style
                    ElevatedButton(
                      onPressed: _navigateNext,
                      style: AppStyles.elevatedButtonStyle,
                      child: Text(
                        'Get Started',
                        style: AppStyles.buttonText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
