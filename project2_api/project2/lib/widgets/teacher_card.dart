// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class TeacherCard extends StatelessWidget {
  final String name;
  final String subject;
  final List<String> qualifications;
  final VoidCallback onTap;

  const TeacherCard({
    Key? key,
    required this.name,
    required this.subject,
    required this.qualifications,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: screenWidth * 0.06,
            child: Text(
              name.substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
            ),
          ),
          title: Text(
            name,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: screenWidth * 0.045),
          ),
          subtitle: Text(
            subject,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[600]),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
