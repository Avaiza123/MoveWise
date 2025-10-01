import 'package:flutter/material.dart';

class DayBox extends StatelessWidget {
  final int dayNumber;
  final bool completed;
  final VoidCallback? onTap;

  const DayBox({
    super.key,
    required this.dayNumber,
    required this.completed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = completed ? Colors.green : Colors.white;
    final border = completed ? Border.all(color: Colors.green) : Border.all(color: Colors.grey.shade300);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: border,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Center(
          child: Text(
            "$dayNumber",
            style: TextStyle(
              color: completed ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
