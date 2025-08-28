// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:project1/core/services/api_service.dart';
import 'package:project1/widgets/custom_app_bar.dart';
import 'package:project1/widgets/search_bar.dart';
import '../models/teacher_model.dart';
import '../screens/teacher_details.dart';
import '../widgets/custom_bottom_nav.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  late Future<List<Teacher>> futureTeachers;
  final ApiService apiService = ApiService('http://192.168.0.250/api_inst/');

  @override
  void initState() {
    super.initState();
    futureTeachers = apiService.fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CustomAppBar(title: 'اعظاء هيئة التدريس'),
        ),
        body: Column(
          children: [
            SearchBarWidget(futureTeachers: futureTeachers),
            Expanded(
              child: FutureBuilder<List<Teacher>>(
                future: futureTeachers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'حدث خطأ: ${snapshot.error}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  }

                  final teachers = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        futureTeachers = apiService.fetchTeachers();
                      });
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: teachers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildTeacherCard(context, teachers[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 3,
          onItemTapped: (index) {
            Navigator.pushNamed(context, '/screen_$index');
          },
        ),
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context, Teacher teacher) {
    double avatarRadius = MediaQuery.of(context).size.width * 0.08;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeacherProfilePage(teacher: teacher),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeacherAvatar(teacher, avatarRadius),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.nameAr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (teacher.qualifications.isNotEmpty)
                    Text(
                      teacher.getQualificationsText(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(
                        Icons.person,
                        teacher.gender == 'male' ? 'ذكر' : 'أنثى',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherAvatar(Teacher teacher, double radius) {
    return Hero(
      tag: 'teacher-${teacher.id}',
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blue[100],
        backgroundImage:
            teacher.imageUrl.isNotEmpty ? NetworkImage(teacher.imageUrl) : null,
        child: teacher.imageUrl.isEmpty
            ? Text(
                teacher.nameAr.isNotEmpty
                    ? teacher.nameAr.characters.first
                    : '?',
                style: TextStyle(
                  fontSize: radius * 0.7,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'لا يوجد معلمون حالياً',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
