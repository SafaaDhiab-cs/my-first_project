// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showInstituteName;
  final List<Widget>? actions; // إضافة خاصية actions

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showInstituteName = false,
    this.actions, // جعلها اختيارية
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = ModalRoute.of(context)?.canPop ?? false;

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF195F97),
            Color(0xFF2692E9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (canGoBack)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  if (showInstituteName) ...[
                    Image.asset(
                      'assets/images/logo3.png',
                      height: 80,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "معهد التعليم أولاً",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ] else ...[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ],
              ),
              if (actions != null) Row(children: actions!),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
