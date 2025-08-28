// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget CustomIconButton(BuildContext context, IconData icon, String label,
    Color color, String routeName) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routeName);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    ),
  );
}
