// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../models/teacher_model.dart';
import '../screens/teacher_details.dart';

class TeacherSearchDelegate extends SearchDelegate {
  final Future<List<Teacher>> futureTeachers;

  TeacherSearchDelegate(this.futureTeachers);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    return FutureBuilder<List<Teacher>>(
      future: futureTeachers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final results = snapshot.data!
            .where((teacher) =>
                teacher.nameAr.contains(query) ||
                teacher.getQualificationsText().contains(query))
            .toList();

        if (results.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد نتائج مطابقة',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
          );
        }

        return ListView(
          children: results.map((teacher) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: teacher.imageUrl.isNotEmpty
                    ? NetworkImage(teacher.imageUrl)
                    : null,
                child: teacher.imageUrl.isEmpty
                    ? Text(teacher.nameAr.characters.first)
                    : null,
              ),
              title: Text(
                teacher.nameAr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                teacher.getQualificationsText(),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeacherProfilePage(teacher: teacher),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
