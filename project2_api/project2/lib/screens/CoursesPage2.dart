// ignore_for_file: file_names, library_private_types_in_public_api, unused_local_variable

import 'package:flutter/material.dart';
import 'package:project1/core/services/api_service.dart';
import 'package:project1/models/department_model.dart';
import 'package:project1/screens/CoursesPage.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';

class CoursesPage2 extends StatefulWidget {
  const CoursesPage2({super.key});

  @override
  _CoursesPage2State createState() => _CoursesPage2State();
}

class _CoursesPage2State extends State<CoursesPage2> {
  late Future<List<Department>> departments;

  @override
  void initState() {
    super.initState();
    departments =
        ApiService('http://192.168.0.250/api_inst/').fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(title: 'الأقسام الأكاديمية'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          return FutureBuilder<List<Department>>(
            future: departments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF195F97)),
                      ),
                      SizedBox(height: 16),
                      Text('جاري تحميل الأقسام...',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 50, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('حدث خطأ: ${snapshot.error}',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline,
                          size: 50, color: Color(0xFF195F97)),
                      SizedBox(height: 16),
                      Text('لا توجد أقسام متاحة حالياً',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                );
              } else {
                final departments = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 24 : 16,
                    vertical: 8,
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9, // تم تقليله لتوفير مساحة أكبر للنص
                    ),
                    itemCount: departments.length,
                    itemBuilder: (context, index) {
                      return _buildDepartmentCard(context, departments[index]);
                    },
                  ),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onItemTapped: (index) {
          Navigator.pushNamed(context, '/screen_$index');
        },
      ),
    );
  }

  Widget _buildDepartmentCard(BuildContext context, Department department) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursesPage(departmentId: department.id),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF195F97),
                Color(0xFF2692E9),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    department.departmentName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
