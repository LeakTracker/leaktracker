import 'package:flutter/material.dart';
import 'package:water_loss_project/constant/constant.dart';

class CustomBadge extends StatelessWidget {
  // Variables
  final String title;
  final Color bgColor;
  final Color textColor;

  const CustomBadge({
    super.key,
    required this.title,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 3.0,
      ),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(100.0)),
      child: Text(
        title,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w800, fontSize: 10.0),
      ),
    );
  }
}
