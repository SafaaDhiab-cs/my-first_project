// ignore_for_file: avoid_print

class TeacherEvaluation {
  final int courseSessionId;
  final String courseName;
  final int teacherId;
  final String teacherName;
  final String departmentName;

  TeacherEvaluation({
    required this.courseSessionId,
    required this.courseName,
    required this.teacherId,
    required this.teacherName,
    required this.departmentName,
  });

  factory TeacherEvaluation.fromJson(Map<String, dynamic> json) {
    try {
      // حل المشكلة الرئيسية: استخدام أسماء الحقول الصحيحة كما تأتي من API
      return TeacherEvaluation(
        courseSessionId: _parseInt(json['course_session_id'] ?? json['session_id'] ?? 0),
        courseName: json['course_name']?.toString() ?? json['courseName']?.toString() ?? 'غير معروف',
        teacherId: _parseInt(json['teacher_id'] ?? json['teacherId'] ?? 0),
        teacherName: json['teacher_name']?.toString() ?? json['teacherName']?.toString() ?? 'غير معروف',
        departmentName: json['department_name']?.toString() ?? json['departmentName']?.toString() ?? 'غير معروف',
      );
    } catch (e) {
      print('Error parsing TeacherEvaluation: $e');
      print('JSON data: $json');
      throw Exception('فشل في تحويل بيانات المدرس');
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}