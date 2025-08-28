// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import, use_key_in_widget_constructors, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:project1/screens/CoursesPage2.dart';
import 'package:project1/screens/payment.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/screens/Announcementspage.dart';
import 'package:project1/screens/attendance.dart';
import 'package:project1/screens/change_password.dart';
import 'package:project1/screens/ChatBotpage.dart';
import 'package:project1/screens/Login_screen.dart';
import 'package:project1/screens/Degree%20details.dart';
import 'package:project1/screens/current_courses_page.dart';
import 'package:project1/screens/teacher_screen.dart';
import 'package:project1/screens/Teatcher_elev.dart';
import 'package:project1/screens/about_us.dart';
import 'package:project1/screens/courses_eval.dart';
import 'package:project1/screens/dashboard.dart';
import 'package:project1/screens/home/home_page.dart';
import 'package:project1/screens/unpaid_payment.dart';
import 'package:project1/screens/profile_page.dart';
import 'package:project1/screens/splash_screen.dart';
import 'package:project1/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AE'), // تعيين اللغة العربية كلغة افتراضية
      supportedLocales: [
        const Locale('ar', 'AE'), // اللغة العربية
        const Locale('en', 'US'), // اللغة الإنجليزية
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        fontFamily: 'Tajawal', // استخدم خطًا يدعم العربية
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // يضمن عرض التطبيق من اليمين لليسار
          child: child!,
        );
      },
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => SplashScreen(),
        AppRoutes.home: (context) => StudentDashboard(),
        AppRoutes.login: (context) => LoginScreen(), // ربط صفحة تسجيل الدخول
        AppRoutes.announcements: (context) => AnnouncementsPage(),
        AppRoutes.chatbot: (context) => ChatBotPage(),
        AppRoutes.aboutUs: (context) => Aboutus(),
        AppRoutes.teachers: (context) => TeacherScreen(),
        AppRoutes.teacherEval: (context) => TeacherRatingScreen(),
        AppRoutes.currentCourses: (context) {
          try {
            final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>? ??
                {};
            final studentId = args['student_id'] is int
                ? args['student_id']
                : int.tryParse(args['student_id']?.toString() ?? '') ?? 0;

            return CurrentCoursesPage(studentId: studentId);
          } catch (e) {
            print('Error in current courses route: $e');
            return Scaffold(
              body: Center(child: Text('حدث خطأ في تحميل الصفحة')),
            );
          }
        },
        AppRoutes.courses: (context) => CoursesPage2(),
        AppRoutes.profile: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ProfilePage(studentId: args['studentId']);
        },
        AppRoutes.changePassword: (context) => ChangePasswordPage(),
        // AppRoutes.courseEval: (context) => CourseRatingScreen(),

        // في جزء تعريف المسارات (routes)
        AppRoutes.courseEval: (context) {
          // استرجاع بيانات الطالب من arguments
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final studentId = arguments?['student_id'] ?? 0;

          return CourseRatingScreen(studentId: studentId);
        },

        AppRoutes.attendance: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          if (args == null || args['student_id'] == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لم يتم التعرف على الطالب'),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('العودة'),
                    ),
                  ],
                ),
              ),
            );
          }

          return AttendanceScreen(
            studentId: args['student_id'] as int,
          );
        },
        AppRoutes.pay: (context) {
          // الحصول على الـ studentId من المسار
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final studentId =
              args?['studentId'] ?? 0; // قيمة افتراضية إذا لم يتم التمرير

          return PaymentScreen(studentId: studentId);
        },
        AppRoutes.dashboard: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          return DashboardScreen(); // تم إزالة userData من هنا
        },
      },
    );
  }
}
