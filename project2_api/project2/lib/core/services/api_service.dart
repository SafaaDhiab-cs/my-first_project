// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/models/StudentNotification_model.dart';
import 'package:project1/models/announcement_model.dart';
import 'package:project1/models/attendance_model.dart';
import 'package:project1/models/changepassmodel.dart';
import 'package:project1/models/course2_model.dart';
import 'package:project1/models/course_evaluation_model.dart';
import 'package:project1/models/current_course_model.dart';
import 'package:project1/models/get_studentcourse.dart';
import 'package:project1/models/inputpayment_model.dart';

// import 'package:project1/models/course_model.dart';
import 'package:project1/models/institute.dart';
import 'package:project1/models/login_model.dart';
import 'package:project1/models/department_model.dart';
import 'package:project1/models/payment.dart';
import 'package:project1/models/studen_profile_model.dart';
// import 'package:project1/models/teacher_eval_model.dart';
import 'package:project1/models/teacher_model.dart';


class ApiService {
  final String baseUrl;
   final String apiKey; // تعريف apiKey

  ApiService(this.baseUrl, {this.apiKey = ''}); // تعديل المُنشئ

  

  // استدعاء بيانات المعهد
  Future<Institute> fetchInstitute() async {
    final response = await http.get(Uri.parse('$baseUrl/about_us.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Institute.fromJson(jsonData);
    } else {
      throw Exception('فشل في تحميل بيانات المعهد');
    }
  }

  Future<List<Announcement>> fetchAnnouncements() async {
    final response = await http.get(Uri.parse('$baseUrl/announcements.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Announcement.fromJson(json)).toList();
    } else {
      throw Exception('فشل تحميل الإعلانات: ${response.reasonPhrase}');
    }
  }

  Future<List<Teacher>> fetchTeachers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/teachers.php'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse["status"] == "success") {
          List<dynamic> teacherList = jsonResponse["teachers"];
          return teacherList
              .map((teacher) => Teacher.fromJson(teacher))
              .toList();
        } else {
          throw Exception(jsonResponse["message"] ?? 'فشل في جلب البيانات');
        }
      } else {
        throw Exception('فشل في الاتصال بالخادم: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching teachers: $e');
      throw Exception('حدث خطأ أثناء جلب بيانات المعلمين');
    }
  }

  // جلب الأقسام
  Future<List<Department>> fetchDepartments() async {
    final response =
        await http.get(Uri.parse('$baseUrl/get_course.php?action=departments'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse["status"] == "success") {
        List<dynamic> departmentList = jsonResponse["departments"];
        return departmentList
            .map((department) => Department.fromJson(department))
            .toList();
      } else {
        throw Exception('فشل في جلب الأقسام');
      }
    } else {
      throw Exception('فشل في جلب الأقسام: ${response.reasonPhrase}');
    }
  }

  // جلب الكورسات بناءً على القسم
  Future<List<Course>> fetchCourses(int departmentId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/get_course.php?action=courses&department_id=$departmentId'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Response: $jsonResponse'); // طباعة الاستجابة للتحقق
      if (jsonResponse["status"] == "success") {
        List<dynamic> courseList = jsonResponse["courses"];
        return courseList.map((course) => Course.fromJson(course)).toList();
      } else {
        throw Exception('فشل في جلب الكورسات');
      }
    } else {
      throw Exception('فشل في جلب الكورسات: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    final url = Uri.parse('$baseUrl/login.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final studentId = int.tryParse(
                  responseData['data']['student_id']?.toString() ?? '0') ??
              0;

          return {
            'success': true,
            'userData': {
              'id': responseData['data']['user_id'],
              'name': responseData['data']['name'],
              'student_id': studentId,
            }
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'خطأ في تسجيل الدخول'
          };
        }
      } else {
        throw Exception('فشل الاتصال بالخادم: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  Future<StudentProfile> fetchStudentProfile(int studentId) async {
    final url = Uri.parse('${baseUrl}student.php?id=$studentId');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      debugPrint('API Response: ${response.body}'); // هذه السطر الجديد

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return StudentProfile.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'فشل جلب البيانات');
        }
      } else {
        throw Exception('خطأ في الخادم: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال');
    } catch (e) {
      debugPrint('Error details: $e'); // هذه السطر الجديد
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  Future<List<Course1>> fetchCurrentCourses(int studentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/current_course.php?student_id=$studentId'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return (data['courses'] as List)
              .map((courseJson) => Course1.fromJson(courseJson))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'لا توجد دورات مسجلة');
        }
      } else {
        throw Exception('خطأ في السيرفر: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال');
    } catch (e) {
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  Future<List<CourseEvaluation>> getCompletedCourses(int studentId) async {
    if (studentId <= 0) {
      throw Exception('Invalid student ID');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_completed_courses.php?student_id=$studentId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      final data = json.decode(response.body);
      print('Completed courses response: $data');

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return (data['courses'] as List)
              .map((json) => CourseEvaluation.fromJson(json))
              .toList();
        } else {
          throw Exception(
              data['message'] ?? 'Failed to load completed courses');
        }
      } else {
        throw Exception(
            'Server error: ${response.statusCode} - ${data['message'] ?? 'Unknown error'}');
      }
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال بالخادم');
    } catch (e) {
      throw Exception('حدث خطأ أثناء تحميل الدورات: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> submitCourseRating({
    required int studentId,
    required int courseSessionId,
    required int courseId,
    required int rating,
    String feedback = '',
  }) async {
    try {
      // التحقق من صحة المدخلات
      if (studentId <= 0 || courseSessionId <= 0 || courseId <= 0) {
        throw Exception('Invalid IDs provided');
      }

      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      final Map<String, dynamic> requestBody = {
        'student_id': studentId,
        'course_session_id': courseSessionId,
        'course_id': courseId,
        'rating': rating,
        'feedback': feedback,
      };

      print('Sending rating request with data: $requestBody');

      final response = await http.post(
        Uri.parse('$baseUrl/submit_rating.php'),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      final responseData = json.decode(response.body);
      print('Received response: $responseData');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'تم تقديم التقييم بنجاح',
          'data': responseData,
        };
      } else {
        throw Exception(responseData['message'] ?? 'فشل في إرسال التقييم');
      }
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال بالخادم');
    } on http.ClientException {
      throw Exception('فشل في الاتصال بالخادم');
    } catch (e) {
      throw Exception('حدث خطأ أثناء الإرسال: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> changePassword(ChangePasswordModel data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/changepass.php'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'فشل في تغيير كلمة المرور');
      }
    } catch (e) {
      throw Exception('حدث خطأ في الاتصال: ${e.toString()}');
    }
  }

  Future<List<AttendanceRecord>> getStudentAttendance(int studentId) async {
    try {
      final url = Uri.parse('$baseUrl/attendance.php?student_id=$studentId');
      print('Requesting: $url'); // لتتبع الطلب

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      print(
          'Response: ${response.statusCode} - ${response.body}'); // لتتبع الاستجابة

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          try {
            final attendanceList = (data['attendance'] as List?) ?? [];
            return attendanceList.map((json) {
              try {
                return AttendanceRecord.fromJson(json);
              } catch (e) {
                print('Error parsing item: $e\nJSON: $json');
                throw Exception('Invalid attendance data format');
              }
            }).toList();
          } catch (e) {
            throw Exception('Failed to parse attendance data: ${e.toString()}');
          }
        } else {
          throw Exception(
              data['message']?.toString() ?? 'Failed to load attendance data');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout');
    } catch (e) {
      throw Exception('Error fetching attendance: ${e.toString()}');
    }
  }
  
   Future<List<StudentNotification>> fetchStudentNotifications(int studentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student_notivacation.php?student_id=$studentId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return (data['notifications'] as List)
              .map((json) => StudentNotification.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load notifications');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout');
    } catch (e) {
      throw Exception('Error fetching notifications: ${e.toString()}');
    }
  }

  Future<void> markNotificationsAsRead(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mark_notification_as_read.php'),
        body: {'student_id': studentId.toString()},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notifications as read');
      }
      
      final data = json.decode(response.body);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to mark notifications as read');
      }
    } catch (e) {
      throw Exception('Error marking notifications as read: ${e.toString()}');
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mark_notification_as_read.php'),
        body: {'notification_id': notificationId.toString()},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
      
      final data = json.decode(response.body);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to mark notification as read');
      }
    } catch (e) {
      throw Exception('Error marking notification as read: ${e.toString()}');
    }
  }

  Future<int> getUnreadNotificationsCount(int studentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_unread.php?student_id=$studentId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['count'] ?? 0;
        } else {
          throw Exception(data['message'] ?? 'Failed to get unread count');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout');
    } catch (e) {
      throw Exception('Error getting unread count: ${e.toString()}');
    }
  }


//   Future<List<StudentCourse>> getStudentCourses(int studentId) async {
//   try {
//     final response = await http.get(
//       Uri.parse('$baseUrl/get_registered_courses.php?student_id=$studentId'),
//       headers: {'Accept': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['success'] == true) {
//         return (data['courses'] as List)
//             .map((course) => StudentCourse.fromJson(course))
//             .toList();
//       } else {
//         throw Exception(data['message'] ?? 'Failed to load courses');
//       }
//     } else {
//       throw Exception('Failed to load courses: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Error loading courses: ${e.toString()}');
//   }
// }


 Future<List<StudentCourse>> getStudentCourses(int studentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_registered_courses.php?student_id=$studentId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        List<dynamic> coursesData = data['courses'] ?? [];
        return coursesData.map((courseJson) => StudentCourse.fromJson(courseJson)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load student courses');
      }
    } catch (e) {
      throw Exception('Error loading student courses: ${e.toString()}');
    }
  }

 Future<List<Payment>> getPaidPayments(int studentId, int courseId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/get_paid_payments.php?student_id=$studentId&course_id=$courseId'),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 15));

    final data = json.decode(response.body);
    if (data['success'] == true) {
      return (data['payments'] as List)
          .map((json) => Payment.fromJson(json))
          .toList();
    } else {
      throw Exception(data['message']?.toString() ?? 'Failed to load paid payments');
    }
  } catch (e) {
    throw Exception('Error fetching payments: ${e.toString()}');
  }
}

Future<List<Payment>> getUnpaidPayments(int studentId, int courseId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/get_unpaid_payments.php?student_id=$studentId&course_id=$courseId'),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 15));

    final data = json.decode(response.body);
    if (data['success'] == true) {
      return (data['payments'] as List)
          .map((json) => Payment.fromJson(json))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to load unpaid payments');
    }
  } catch (e) {
    throw Exception('Error fetching unpaid payments: ${e.toString()}');
  }
}
  

   
  
}
