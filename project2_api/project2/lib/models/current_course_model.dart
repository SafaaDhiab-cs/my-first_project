class Course1 {
  final String id;
  final String name;
  final String category;
  final bool isCompleted;
  final double practicalDegree;
  final double finalDegree;
  final double attendanceDegree;
  final double totalDegree;
  final String status;

  Course1({
    required this.id,
    required this.name,
    required this.category,
    required this.isCompleted,
    required this.practicalDegree,
    required this.finalDegree,
    required this.attendanceDegree,
    required this.totalDegree,
    required this.status,
  });

  factory Course1.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    bool isCompleted = false;
    if (json['is_completed'] != null) {
      isCompleted = json['is_completed'] == 1 || 
                   json['is_completed'] == true || 
                   (json['is_completed'] is String && 
                    (json['is_completed'].toLowerCase() == 'true' || 
                     json['is_completed'] == 'مكتمل'));
    }

    return Course1(
      id: json['course_id']?.toString() ?? '0',
      name: json['course_name']?.toString() ?? 'غير معروف',
      category: json['category']?.toString() ?? '',
      isCompleted: isCompleted,
      practicalDegree: parseDouble(json['practical_degree']),
      finalDegree: parseDouble(json['final_degree']),
      attendanceDegree: parseDouble(json['attendance_degree']),
      totalDegree: parseDouble(json['total_degree']),
      status: json['status']?.toString() ?? '',
    );
  }
}