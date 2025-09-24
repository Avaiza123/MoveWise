import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_appbar.dart';

class QnaScreen extends StatelessWidget {
  const QnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> qnaList = [
      {
        "question": "💡 How do I calculate BMI?",
        "answer":
        "Your BMI is calculated using your weight (kg) divided by the square of your height (m²). Example: 70 ÷ (1.75 × 1.75) = 22.9"
      },
      {
        "question": "🎯 Can I change my goals later?",
        "answer":
        "Yes! You can always update your fitness goals anytime in the Profile section."
      },
      {
        "question": "🔒 Is my data safe?",
        "answer":
        "Absolutely. We use Firebase Authentication and Firestore with strict security rules to protect your information."
      },
      {
        "question": "🥗 Do I need a special diet?",
        "answer":
        "Not necessarily. A balanced diet with protein, carbs, fats, and plenty of water works best for most people."
      },
      {
        "question": "⏱ How often should I exercise?",
        "answer":
        "Experts recommend at least 150 minutes of moderate activity or 75 minutes of intense exercise per week."
      },
      {
        "question": "🔥 How do I stay motivated?",
        "answer":
        "Set small achievable goals, track your progress, and celebrate every milestone. Consistency is key!"
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFBE9E7),
            Color(0xFFD7CCC8),
            Color(0xFFEFEBE9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: "Q & A"),
        body: ListView.builder(
          padding: const EdgeInsets.all(AppSizes.padding),
          itemCount: qnaList.length,
          itemBuilder: (context, index) {
            final qna = qnaList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ExpansionTile(
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  tilePadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  title: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor.withOpacity(0.8),
                              AppColors.primaryColorDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.question_answer,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          qna["question"]!,
                          style: GoogleFonts.merriweatherSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColorDark,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        qna["answer"]!,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          color: AppColors.black.withOpacity(0.85),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
