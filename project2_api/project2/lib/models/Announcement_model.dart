// ignore_for_file: file_names

class Announcement {
  final String? image;
  final String content;
  final String? startDate;
  final String? endDate;

  Announcement({
    this.image,
    required this.content,
    this.startDate,
    this.endDate,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      image: json['image'] != null && json['image'] != '' ? json['image'] : null,
      content: json['content'] ?? 'بدون عنوان',
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }
}
