class TeacherEvaluation {
  final int teacherId;
  final String teacherName;
  final int courseId;
  final String courseName;
  double rating; // <-- هنا غيرناها من int إلى double
  String feedback;
  bool isRated;

  TeacherEvaluation({
    required this.teacherId,
    required this.teacherName,
    required this.courseId,
    required this.courseName,
    this.rating = 0.0, // <-- تأكد أن القيمة الافتراضية double
    this.feedback = '',
    this.isRated = false,
  });

  factory TeacherEvaluation.fromJson(Map<String, dynamic> json) {
    return TeacherEvaluation(
      teacherId: json['teacher_id'] as int,
      teacherName: json['teacher_name'] as String,
      courseId: json['course_id'] as int,
      courseName: json['course_name'] as String,
      rating: (json['rating'] ?? 0).toDouble(), // <-- تأكد أن تكون double
      feedback: json['feedback'] as String? ?? '',
      isRated: json['is_rated'] as bool? ?? false,
    );
  }
}
