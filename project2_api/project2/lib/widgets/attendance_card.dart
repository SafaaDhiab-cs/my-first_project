// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final String title;
  final Color color;
  final int count;

  const AttendanceCard({
    Key? key,
    required this.title,
    required this.color,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                CircleAvatar(
                  backgroundColor: color,
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
