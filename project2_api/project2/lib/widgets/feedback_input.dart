// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class FeedbackInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  const FeedbackInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      enabled: enabled, // تعطيل الإدخال عند الحاجة
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }
}
