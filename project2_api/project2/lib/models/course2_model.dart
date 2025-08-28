class Course {
  final int id;
  final String courseName;
  final int duration;
  final int state;
  final double price; // تأكد من إضافة هذه السطر
  final String? description;

  Course({
    required this.id,
    required this.courseName,
    required this.duration,
    required this.state,
    required this.price, // تأكد من إضافة هذه السطر
    this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      courseName: json['course_name'] ?? 'غير متوفر',
      duration: json['duration'] ?? 0,
      state: json['state'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0, // تأكد من إضافة هذه السطر
    );
  }
}