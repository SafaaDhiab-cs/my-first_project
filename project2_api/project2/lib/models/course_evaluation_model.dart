class CourseEvaluation {
  final int courseSessionId;
  final int courseId;
  final String courseName;
  int rating;
  String feedback;
  bool isRated;

  CourseEvaluation({
    required this.courseSessionId,
    required this.courseId,
    required this.courseName,
    this.rating = 0,
    this.feedback = '',
    required this.isRated,
  });

  factory CourseEvaluation.fromJson(Map<String, dynamic> json) {
    try {
      return CourseEvaluation(
        courseSessionId: json['course_session_id'] ?? 0,
        courseId: json['course_id'] ?? 0,
        courseName: json['course_name'] ?? '',
        isRated: (json['is_rated'] ?? 0) == 1,
      );
    } catch (e) {
      throw Exception('Failed to parse CourseEvaluation: ${e.toString()}');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'course_session_id': courseSessionId,
      'course_id': courseId,
      'course_name': courseName,
      'rating': rating,
      'feedback': feedback,
      'is_rated': isRated ? 1 : 0,
    };
  }
}