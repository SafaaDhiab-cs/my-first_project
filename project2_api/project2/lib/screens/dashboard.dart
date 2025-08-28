// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:project1/screens/NotificationsScreen.dart';
import 'package:project1/screens/courses_eval.dart';
import 'package:project1/screens/payment.dart';
import 'package:project1/screens/profile_page.dart';
import '../widgets/custom_app_bar.dart';
import '../routes/app_routes.dart';
import '../widgets/grid_button.dart';
import '../core/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int unreadCount = 0;
  late ApiService apiService;
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    apiService = ApiService('http://192.168.0.250/api_inst/');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    _loadUnreadNotificationsCount();
  }

  Future<void> _loadUnreadNotificationsCount() async {
    try {
      final count = await apiService
          .getUnreadNotificationsCount(userData['student_id'] ?? 0);
      if (mounted) {
        setState(() {
          unreadCount = count;
        });
      }
    } catch (e) {
      print('Error loading unread notifications count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    final currentYear = DateTime.now().year;
    final academicYear = '$currentYear-${currentYear + 1}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: CustomAppBar(
            title: 'لوحة التحكم',
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                tooltip: 'الإشعارات',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationsScreen(
                        studentId: userData['student_id'] ?? 0,
                      ),
                    ),
                  ).then((_) {
                    _loadUnreadNotificationsCount();
                  });
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF195F97), Color(0xFF2692E9)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.04,
                vertical: screenSize.height * 0.02,
              ),
              child: Column(
                children: [
                  _buildWelcomeSection(
                      context, userData, academicYear, isTablet),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildGridMenu(context, isTablet, userData),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context,
      Map<String, dynamic> userData, String academicYear, bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "مرحبا بك",
                style: TextStyle(
                  fontSize: isTablet ? screenWidth * 0.06 : screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenWidth * 0.03),
              Text(
                userData['name'] ?? 'مستخدم',
                style: TextStyle(
                  fontSize: isTablet ? screenWidth * 0.05 : screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenWidth * 0.1),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.015,
                  horizontal: screenWidth * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  academicYear,
                  style: TextStyle(
                    fontSize:
                        isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  studentId: userData['student_id'] ?? 0,
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: isTablet ? screenWidth * 0.06 : screenWidth * 0.08,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: isTablet ? screenWidth * 0.06 : screenWidth * 0.08,
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridMenu(
      BuildContext context, bool isTablet, Map<String, dynamic> userData) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int getStudentId() {
      try {
        if (userData['student_id'] == null) return 0;
        if (userData['student_id'] is int) return userData['student_id'];
        if (userData['student_id'] is String) {
          return int.tryParse(userData['student_id']) ?? 0;
        }
        return 0;
      } catch (e) {
        print('Error parsing student_id: $e');
        return 0;
      }
    }

    final buttons = [
      GridButton(
        title: 'الدورات الحالية',
        icon: Icons.book,
        onPressed: () {
          final studentId = getStudentId();
          if (studentId > 0) {
            Navigator.pushNamed(
              context,
              AppRoutes.currentCourses,
              arguments: {'student_id': studentId},
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('لا يمكن عرض الكورسات - معرف الطالب غير صالح')),
            );
          }
        },
      ),
      GridButton(
        title: 'الحضور',
        icon: Icons.event_available,
        onPressed: () {
          final studentId = getStudentId();
          if (studentId <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'تعذر تحميل بيانات الحضور - الرجاء التأكد من تسجيل الدخول')),
            );
            return;
          }
          Navigator.pushNamed(
            context,
            AppRoutes.attendance,
            arguments: {'student_id': studentId},
          );
        },
      ),

      GridButton(
        title: 'تقييم الدورات',
        icon: Icons.star_rate,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseRatingScreen(
                studentId: userData['student_id'],
              ),
            ),
          );
        },
      ),

      GridButton(
        title: 'بوت الذكاء',
        icon: Icons.smart_toy,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.chatbot),
      ),
      GridButton(
        title: 'المدرسون',
        icon: Icons.person,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.teachers),
      ),
      // GridButton(
      //   title: 'تقييم المدرسون',
      //   icon: Icons.assessment,
      //   onPressed: () => Navigator.pushNamed(context, AppRoutes.teacherEval),
      // ),
      GridButton(
        title: 'الدفع',
        icon: Icons.payment,
        onPressed: () {
          final studentId = getStudentId();
          if (studentId > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(studentId: studentId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('لا يمكن عرض صفحة الدفع - معرف الطالب غير صالح')),
            );
          }
        },
      ),
      GridButton(
        title: 'تغيير كلمة المرور',
        icon: Icons.lock,
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.changePassword,
            arguments: {
              'user_id': userData['id'],
              'student_id': userData['student_id'],
            },
          );
        },
      ),
      GridButton(
        title: 'تسجيل الخروج',
        icon: Icons.logout,
        onPressed: () => Navigator.pop(context),
      ),
    ];

    return GridView.count(
      crossAxisCount: isTablet ? 3 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: screenWidth * 0.04,
      crossAxisSpacing: screenWidth * 0.04,
      childAspectRatio: isTablet ? 1.3 : 1.1,
      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
      children: buttons,
    );
  }
}
