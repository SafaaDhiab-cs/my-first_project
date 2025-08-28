// ignore_for_file: use_super_parameters, library_private_types_in_public_api, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:project1/models/current_course_model.dart';
import 'package:project1/screens/Degree%20details.dart';
import '../core/services/api_service.dart';
import '../widgets/custom_app_bar.dart';

class CurrentCoursesPage extends StatefulWidget {
  final int studentId;

  const CurrentCoursesPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _CurrentCoursesPageState createState() => _CurrentCoursesPageState();
}

class _CurrentCoursesPageState extends State<CurrentCoursesPage> {
  late Future<List<Course1>> _coursesFuture;
  final ApiService _apiService = ApiService('http://192.168.0.250/api_inst/');

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    setState(() {
      _coursesFuture = _apiService.fetchCurrentCourses(widget.studentId);
    });
  }

  Future<void> _refreshCourses() async {
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'الدورات الحالية'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: _refreshCourses,
            color: Colors.blue,
            displacement: screenHeight * 0.03,
            child: FutureBuilder<List<Course1>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 3,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildErrorWidget(screenWidth, screenHeight, constraints);
                }

                final courses = snapshot.data ?? [];
                if (courses.isEmpty) {
                  return _buildEmptyWidget(screenWidth, screenHeight, constraints);
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _handleCourseTap(course),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      course.name,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (course.isCompleted)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.03,
                                            vertical: screenHeight * 0.005,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                              color: Colors.blue.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            'الدرجه',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: screenWidth * 0.035,
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: screenWidth * 0.02),
                                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                course.category,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (course.isCompleted) ...[
                                SizedBox(height: screenHeight * 0.025),
                                LinearProgressIndicator(
                                  value: course.totalDegree / 100,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                                  minHeight: screenHeight * 0.01,
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'الدرجة النهائية:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${course.totalDegree.toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(double screenWidth, double screenHeight, BoxConstraints constraints) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: constraints.maxHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: screenWidth * 0.15, color: Colors.red),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(
                  'حدث خطأ في تحميل البيانات',
                  style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.015,
                  ),
                ),
                onPressed: _refreshCourses,
                child: Text('إعادة المحاولة', style: TextStyle(fontSize: screenWidth * 0.04)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(double screenWidth, double screenHeight, BoxConstraints constraints) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: constraints.maxHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list_alt, size: screenWidth * 0.2, color: Colors.blue),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'لا توجد دورات مسجلة حالياً',
                style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.grey[700]),
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.015,
                  ),
                ),
                onPressed: _refreshCourses,
                child: Text('تحديث البيانات', style: TextStyle(fontSize: screenWidth * 0.04)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCourseTap(Course1 course) {
    if (course.isCompleted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DegreeDetails(course: course),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'الدرجات غير متاحة حتى انتهاء الكورس',
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
