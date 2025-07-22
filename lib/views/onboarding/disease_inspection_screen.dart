import 'package:flutter/material.dart';

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  final Set<String> selectedDiseases = {};

  final List<Map<String, dynamic>> diseases = [
    {'name': 'Diabetes', 'icon': Icons.bloodtype},
    {'name': 'Blood Pressure', 'icon': Icons.favorite},
    {'name': 'Knee Pain', 'icon': Icons.accessibility_new},
    {'name': 'Ankle Pain', 'icon': Icons.directions_walk},
    {'name': 'Asthma', 'icon': Icons.air},
    {'name': 'Back Pain', 'icon': Icons.event_seat},
    {'name': 'Arthritis', 'icon': Icons.healing},
    {'name': 'Migraine', 'icon': Icons.psychology},
    {'name': 'No Issue', 'icon': Icons.not_interested},
  ];

  void _navigateNext() {
    if (selectedDiseases.isNotEmpty) {
      Navigator.pushNamed(context, '/summary');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please select at least one condition to continue',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  void _toggleDisease(String disease) {
    setState(() {
      if (selectedDiseases.contains(disease)) {
        selectedDiseases.remove(disease);
      } else {
        selectedDiseases.add(disease);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.teal.shade600.withOpacity(0.95),
          elevation: 6,
          centerTitle: true,
          title: const Text(
            'Health Conditions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
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
            const Text(
              'Do you have any of these?',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 30),

            // Disease List
            Expanded(
              child: ListView.builder(
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  final disease = diseases[index];
                  final String name = disease['name'];
                  final IconData icon = disease['icon'];
                  final bool isSelected = selectedDiseases.contains(name);

                  return GestureDetector(
                    onTap: () => _toggleDisease(name),
                    child: Card(
                      color: isSelected ? Colors.teal.shade300 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? Colors.teal.shade700 : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                        child: Row(
                          children: [
                            Icon(icon, color: isSelected ? Colors.white : Colors.teal),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              color: isSelected ? Colors.white : Colors.grey,
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

            // Continue Button
            Center(
              child: ElevatedButton(
                onPressed: _navigateNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
