import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  String selectedUnit = 'kg';
  double weight = 0;
  double? bmi;

  void _navigateToDisease() {
    Navigator.pushNamed(context, '/disease');
  }

  void _calculateBMI(double heightCm) async {
    double weightKg = selectedUnit == 'kg' ? weight : (weight * 0.453592);
    double heightM = heightCm / 100;

    setState(() {
      bmi = weightKg / pow(heightM, 2);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('bmi', bmi!);
  }

  @override
  Widget build(BuildContext context) {
    final heightCm = ModalRoute.of(context)!.settings.arguments as double;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Weight', style: AppStyles.appBarTitle),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ToggleButtons(
                isSelected: [selectedUnit == 'kg', selectedUnit == 'lb'],
                onPressed: (index) {
                  setState(() {
                    selectedUnit = index == 0 ? 'kg' : 'lb';
                  });
                },
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: AppColors.primaryColor,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('KG')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('LB')),
                ],
              ),
              const SizedBox(height: 22),

              Text(
                '${weight.round()} $selectedUnit',
                style: AppStyles.value,
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 500,
                  itemBuilder: (context, index) {
                    double value = index.toDouble();
                    final isSelected = weight.round() == value.round();
                    return GestureDetector(
                      onTap: () => setState(() => weight = value),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          value.round().toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () => _calculateBMI(heightCm),
                style: AppStyles.elevatedButtonStyle,
                child:  Text('Calculate BMI', style: AppStyles.buttonText),
              ),

              const SizedBox(height: 20),

              if (bmi != null) ...[
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 10,
                      maximum: 50,
                      ranges: <GaugeRange>[
                        GaugeRange(startValue: 10, endValue: 16, color: Colors.red.shade900),
                        GaugeRange(startValue: 16, endValue: 17, color: Colors.red),
                        GaugeRange(startValue: 17, endValue: 18.5, color: Colors.orange),
                        GaugeRange(startValue: 18.5, endValue: 25, color: Colors.teal),
                        GaugeRange(startValue: 25, endValue: 30, color: Colors.yellow),
                        GaugeRange(startValue: 30, endValue: 35, color: Colors.orangeAccent),
                        GaugeRange(startValue: 35, endValue: 40, color: Colors.deepOrange),
                        GaugeRange(startValue: 40, endValue: 50, color: Colors.redAccent),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(value: bmi!),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            'BMI: ${bmi!.toStringAsFixed(1)}',
                            style: AppStyles.label,
                          ),
                          angle: 90,
                          positionFactor: 0.8,
                        )
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: _bmiGradientColors(bmi!),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(_bmiIcon(bmi!), size: 40, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        _bmiCategory(bmi!),
                        style: AppStyles.screenTitle.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _bmiSuggestion(bmi!),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _navigateToDisease,
                  style: AppStyles.elevatedButtonStyle,
                  child: Text('Next', style: AppStyles.buttonText),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _bmiSuggestion(double bmi) {
    if (bmi < 16) return 'Severely underweight – Consult a doctor.';
    if (bmi < 17) return 'Moderately underweight – Increase calorie intake.';
    if (bmi < 18.5) return 'Mild thinness – Improve nutrition.';
    if (bmi < 25) return 'Normal – Great job!';
    if (bmi < 30) return 'Overweight – Consider more physical activity.';
    if (bmi < 35) return 'Obese Class I – Plan healthier meals.';
    if (bmi < 40) return 'Obese Class II – Seek medical advice.';
    return 'Obese Class III – Take action immediately!';
  }

  String _bmiCategory(double bmi) {
    if (bmi < 16) return 'Severely Underweight';
    if (bmi < 17) return 'Moderately Underweight';
    if (bmi < 18.5) return 'Mild Thinness';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    if (bmi < 40) return 'Obese Class II';
    return 'Obese Class III';
  }

  IconData _bmiIcon(double bmi) {
    if (bmi < 18.5) return Icons.warning_amber_rounded;
    if (bmi < 25) return Icons.check_circle_outline;
    if (bmi < 30) return Icons.directions_run;
    return Icons.health_and_safety;
  }

  List<Color> _bmiGradientColors(double bmi) {
    if (bmi < 16) return [Colors.red.shade900, Colors.red];
    if (bmi < 17) return [Colors.red, Colors.deepOrange];
    if (bmi < 18.5) return [Colors.orange, Colors.deepOrangeAccent];
    if (bmi < 25) return [Colors.green, Colors.teal];
    if (bmi < 30) return [Colors.yellow.shade700, Colors.orange];
    if (bmi < 35) return [Colors.deepOrange, Colors.orangeAccent];
    if (bmi < 40) return [Colors.deepOrange.shade900, Colors.red];
    return [Colors.redAccent, Colors.red];
  }
}
