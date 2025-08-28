class StudentCourse {
  final int id;
  final String name;
  final int courseId;
  final String? department;
  final int? duration;

  StudentCourse({
    required this.id,
    required this.name,
    required this.courseId,
    this.department,
    this.duration,
  });

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    return StudentCourse(
      id: json['course_id'] ?? 0,
      name: json['name'] ?? 'غير معروف',
      courseId: json['course_id'] ?? 0,
      department: json['department_name']?.toString(),
      duration: json['duration'] != null ? int.tryParse(json['duration'].toString()) : null,
    );
  }
}