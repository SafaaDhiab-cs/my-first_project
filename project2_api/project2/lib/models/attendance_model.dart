class AttendanceRecord {
  final int courseId;
  final String courseName;
  final int totalDays;
  final int attendanceDays;
  final int absenceDays;
  final bool isCompleted;

  AttendanceRecord({
    required this.courseId,
    required this.courseName,
    required this.totalDays,
    required this.attendanceDays,
    required this.absenceDays,
    required this.isCompleted,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
  // دالة مساعدة لتحويل القيم إلى int
  int parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  return AttendanceRecord(
    courseId: parseInt(json['course_id']),
    courseName: json['course_name'] as String? ?? '',
    totalDays: parseInt(json['total_days']),
    attendanceDays: parseInt(json['attendance_days']),
    absenceDays: parseInt(json['absence_days']),
    isCompleted: (parseInt(json['is_completed']) == 1),
  );

  }
}