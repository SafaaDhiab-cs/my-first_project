// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor; // ✅ إضافة لون الأيقونة

  const GridButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.orange, // ✅ جعل اللون اختياريًا مع قيمة افتراضية
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: iconColor, // ✅ استخدام المتغير بدلاً من لون ثابت
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

