// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project1/core/services/api_service.dart';
import 'package:project1/models/attendance_model.dart';
import 'package:project1/routes/app_routes.dart';
import 'package:project1/widgets/custom_app_bar.dart';
import 'package:project1/widgets/custom_bottom_nav.dart';

class AttendanceScreen extends StatefulWidget {
  final int studentId;

  const AttendanceScreen({super.key, required this.studentId});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int _currentIndex = 0;
  late Future<List<AttendanceRecord>> _attendanceFuture;
  AttendanceRecord? _selectedCourse;
  bool _isLoading = false;

  // دالة لحساب الحجم المتجاوب
  double _responsiveSize(double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return size * (screenWidth / 375); // 375 هو عرض iPhone 12 كمرجع
  }

  @override
  void initState() {
    super.initState();
    _attendanceFuture = _loadAttendanceData();
  }

  Future<List<AttendanceRecord>> _loadAttendanceData() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ApiService('http://192.168.0.250/api_inst/');
      final data = await apiService.getStudentAttendance(widget.studentId);
      if (data.isNotEmpty) {
        setState(() {
          _selectedCourse = data.firstWhere(
            (course) => course.isCompleted,
            orElse: () => data.first,
          );
        });
      }
      return data.where((course) => course.isCompleted).toList();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.announcements);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.chatbot);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.aboutUs);
        break;
    }
  }

  Widget _buildHeaderCard(String courseName, int totalDays) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: const Color(0xFF1C6DAD),
      child: Padding(
        padding: EdgeInsets.all(_responsiveSize(16)),
        child: Column(
          children: [
            Icon(
              Icons.school,
              size: _responsiveSize(50),
              color: Colors.white,
            ),
            SizedBox(height: _responsiveSize(10)),
            Text(
              courseName,
              style: TextStyle(
                fontSize: _responsiveSize(20),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _responsiveSize(10)),
            Text(
              'إجمالي أيام الدورة',
              style: TextStyle(
                fontSize: _responsiveSize(18),
                color: Colors.white,
              ),
            ),
            Text(
              '$totalDays يوم',
              style: TextStyle(
                fontSize: _responsiveSize(22),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, int value, Color color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: color,
      child: Padding(
        padding: EdgeInsets.all(_responsiveSize(16)),
        child: Column(
          children: [
            Icon(
              icon,
              size: _responsiveSize(50),
              color: Colors.white,
            ),
            SizedBox(height: _responsiveSize(10)),
            Text(
              title,
              style: TextStyle(
                fontSize: _responsiveSize(18),
                color: Colors.white,
              ),
            ),
            Text(
              '$value يوم',
              style: TextStyle(
                fontSize: _responsiveSize(22),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(AttendanceRecord course) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildInfoCard(
            'أيام الحضور',
            course.attendanceDays,
            Colors.green,
            Icons.check_circle,
          ),
        ),
        SizedBox(width: _responsiveSize(16)),
        Expanded(
          child: _buildInfoCard(
            'أيام الغياب',
            course.absenceDays,
            Colors.red,
            Icons.cancel,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(double attendancePercentage, double absencePercentage) {
    return SizedBox(
      height: _responsiveSize(250),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: attendancePercentage,
              title: '${attendancePercentage.toStringAsFixed(1)}%',
              radius: _responsiveSize(80),
              titleStyle: TextStyle(
                fontSize: _responsiveSize(18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: absencePercentage,
              title: '${absencePercentage.toStringAsFixed(1)}%',
              radius: _responsiveSize(80),
              titleStyle: TextStyle(
                fontSize: _responsiveSize(18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          sectionsSpace: 5,
          centerSpaceRadius: _responsiveSize(50),
          startDegreeOffset: 180,
        ),
      ),
    );
  }

  Widget _buildAttendanceDetailsTable(AttendanceRecord course) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(_responsiveSize(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل الحضور والغياب',
              style: TextStyle(
                fontSize: _responsiveSize(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _responsiveSize(10)),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: const Text(
                        'النسبة',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: const Text(
                        'الأيام',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: const Text(
                        'الحضور',
                        style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: Text(
                        '${course.attendanceDays} يوم',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: const Text(
                        'الغياب',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: Text(
                        '${course.absenceDays} يوم',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: const Text(
                        'الإجمالي',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(_responsiveSize(8)),
                      child: Text(
                        '${course.totalDays} يوم',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceDetails(AttendanceRecord course) {
    int totalDays = course.totalDays;
    double attendancePercentage =
        totalDays == 0 ? 0 : (course.attendanceDays / totalDays) * 100;
    double absencePercentage =
        totalDays == 0 ? 0 : (course.absenceDays / totalDays) * 100;

    return ListView(
      padding: EdgeInsets.all(_responsiveSize(16)),
      children: [
        _buildHeaderCard(course.courseName, totalDays),
        SizedBox(height: _responsiveSize(16)),
        _buildStatisticsRow(course),
        SizedBox(height: _responsiveSize(16)),
        _buildPieChart(attendancePercentage, absencePercentage),
        SizedBox(height: _responsiveSize(16)),
        _buildAttendanceDetailsTable(course),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_responsiveSize(100)),
        child: const CustomAppBar(title: 'نسبة الحضور والغياب'),
      ),
      body: FutureBuilder<List<AttendanceRecord>>(
        future: _attendanceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isLoading) {
            return Center(
              child: CircularProgressIndicator(strokeWidth: _responsiveSize(4)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: _responsiveSize(50),
                    color: Colors.red,
                  ),
                  SizedBox(height: _responsiveSize(16)),
                  Text(
                    'حدث خطأ في تحميل البيانات',
                    style: TextStyle(
                      fontSize: _responsiveSize(20),
                    ),
                  ),
                  SizedBox(height: _responsiveSize(8)),
                  Text(
                    'الخطأ: ${snapshot.error.toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _responsiveSize(16),
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: _responsiveSize(16)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _attendanceFuture = _loadAttendanceData();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(_responsiveSize(12)),
                      child: Text(
                        'إعادة المحاولة',
                        style: TextStyle(
                          fontSize: _responsiveSize(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final courses = snapshot.data ?? [];

          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    size: _responsiveSize(80),
                    color: const Color(0xFF1C6DAD),
                  ),
                  SizedBox(height: _responsiveSize(16)),
                  Text(
                    'لا توجد دورات مكتملة لعرض بيانات الحضور',
                    style: TextStyle(
                      fontSize: _responsiveSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(_responsiveSize(16)),
                child: DropdownButton<AttendanceRecord>(
                  value: _selectedCourse,
                  isExpanded: true,
                  hint: Text(
                    'اختر الدورة',
                    style: TextStyle(
                      fontSize: _responsiveSize(16),
                    ),
                  ),
                  items: courses.map((course) {
                    return DropdownMenuItem<AttendanceRecord>(
                      value: course,
                      child: Text(
                        course.courseName,
                        style: TextStyle(
                          fontSize: _responsiveSize(16),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (course) {
                    if (course != null) {
                      setState(() => _selectedCourse = course);
                    }
                  },
                ),
              ),
              Expanded(
                child: _selectedCourse != null
                    ? _buildAttendanceDetails(_selectedCourse!)
                    : Center(
                        child: Text(
                          'اختر دورة لعرض البيانات',
                          style: TextStyle(
                            fontSize: _responsiveSize(16),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
