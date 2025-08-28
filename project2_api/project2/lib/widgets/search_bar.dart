// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:project1/models/teacher_model.dart';
import 'package:project1/widgets/TeacherSearchDelegate.dart';

class SearchBarWidget extends StatelessWidget {
  final Future<List<Teacher>> futureTeachers;

  const SearchBarWidget({
    Key? key,
    required this.futureTeachers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          showSearch(
            context: context,
            delegate: TeacherSearchDelegate(futureTeachers),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.black), // لون الأيقونة أسود
              SizedBox(width: 8),
              Text(
                'ابحث عن معلم...',
                style: TextStyle(color: Colors.black), // لون النص أسود
              ),
            ],
          ),
        ),
      ),
    );
  }
}
