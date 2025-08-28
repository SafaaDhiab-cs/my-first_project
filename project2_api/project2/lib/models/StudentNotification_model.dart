// ignore_for_file: file_names

class StudentNotification {
  final int id;
  final int studentId;
  final String note;
  final String state;
  final DateTime date;

  StudentNotification({
    required this.id,
    required this.studentId,
    required this.note,
    required this.state,
    required this.date,
  });

  factory StudentNotification.fromJson(Map<String, dynamic> json) {
    return StudentNotification(
      id: json['id'],
      studentId: json['student_id'],
      note: json['note'],
      state: json['state'],
      date: DateTime.parse(json['date']),
    );
  }
}