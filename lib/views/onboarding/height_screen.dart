import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  String selectedUnit = 'cm';
  int heightCm = 0;
  int heightFt = 0;
  int heightIn = 0;

  final TextEditingController cmController = TextEditingController();
  final TextEditingController ftController = TextEditingController();
  final TextEditingController inController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cmController.text = '0';
    ftController.text = '0';
    inController.text = '0';
  }

  void _navigateToWeight() {
    double finalHeightCm = selectedUnit == 'cm'
        ? heightCm.toDouble()
        : ((heightFt * 12 + heightIn) * 2.54);

    Navigator.pushNamed(
      context,
      '/weight',
      arguments: finalHeightCm,
    );
  }

  Widget _buildCmScale() {
    return Expanded(
      child: Column(
        children: [
          TextField(
            controller: cmController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter height in cm'),
            onChanged: (val) {
              final parsed = int.tryParse(val) ?? 0;
              setState(() {
                heightCm = parsed.clamp(0, 250);
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              perspective: 0.003,
              diameterRatio: 1.8,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  heightCm = index;
                  cmController.text = heightCm.toString();
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Center(
                      child: Text(
                        "$index cm",
                        style: index == heightCm
                            ? AppStyles.wheelSelectedText
                            : AppStyles.wheelUnselectedText,
                      ),
                    ),
                  );
                },
                childCount: 251,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFtInScale() {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ftController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Feet'),
                  onChanged: (val) {
                    final parsed = int.tryParse(val) ?? 0;
                    setState(() {
                      heightFt = parsed.clamp(0, 7);
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: inController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Inches'),
                  onChanged: (val) {
                    final parsed = int.tryParse(val) ?? 0;
                    setState(() {
                      heightIn = parsed.clamp(0, 11);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    perspective: 0.003,
                    diameterRatio: 1.8,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        heightFt = index;
                        ftController.text = index.toString();
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: Text(
                              "$index ft",
                              style: index == heightFt
                                  ? AppStyles.wheelSelectedText
                                  : AppStyles.wheelUnselectedText,
                            ),
                          ),
                        );
                      },
                      childCount: 8,
                    ),
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    perspective: 0.003,
                    diameterRatio: 1.8,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        heightIn = index;
                        inController.text = index.toString();
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: Text(
                              "$index in",
                              style: index == heightIn
                                  ? AppStyles.wheelSelectedText
                                  : AppStyles.wheelUnselectedText,
                            ),
                          ),
                        );
                      },
                      childCount: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formattedHeight() {
    if (selectedUnit == 'cm') {
      return "$heightCm cm";
    } else {
      return "$heightFt ft $heightIn in";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Enter Your Height', style: AppStyles.appBarTitle),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ToggleButtons(
                isSelected: [selectedUnit == 'cm', selectedUnit == 'ft'],
                onPressed: (index) {
                  setState(() {
                    selectedUnit = index == 0 ? 'cm' : 'ft';
                  });
                },
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: AppColors.primaryColor,
                textStyle: AppStyles.toggleText,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('CM'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Feet/Inches'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text('Selected Height', style: AppStyles.label),
                const SizedBox(height: 6),
                Text(_formattedHeight(), style: AppStyles.value),
              ],
            ),
            const SizedBox(height: 30),
            if (selectedUnit == 'cm') _buildCmScale() else _buildFtInScale(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _navigateToWeight,
              style: AppStyles.elevatedButtonStyle,
              child: Text('Next', style: AppStyles.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
