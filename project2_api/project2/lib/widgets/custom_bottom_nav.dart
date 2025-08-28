// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromARGB(255, 234, 131, 20),
      unselectedItemColor: const Color.fromARGB(255, 133, 132, 132),
      selectedFontSize: screenWidth * 0.035,
      unselectedFontSize: screenWidth * 0.03,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home, size: screenWidth * 0.07),
            label: 'الرئيسية'),
        BottomNavigationBarItem(
            icon: Icon(Icons.campaign, size: screenWidth * 0.07),
            label: 'الإعلانات'),
        BottomNavigationBarItem(
            icon: Icon(Icons.help_outline, size: screenWidth * 0.07),
            label: 'اسأل'),
        BottomNavigationBarItem(
            icon: Icon(Icons.info, size: screenWidth * 0.07),
            label: 'تواصل'),
      ],
      onTap: onItemTapped,
    );
  }
}
