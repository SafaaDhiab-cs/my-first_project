class Teacher {
  final int id;
  final String nameAr;
  final String nameEn;
  final String email;
  final String address;
  final String gender;
  final List<String> phoneNumbers;
  final List<Qualification> qualifications;
  final String imageUrl;

  Teacher({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.email,
    required this.address,
    required this.gender,
    required this.phoneNumbers,
    required this.qualifications,
    required this.imageUrl,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    // معالجة أرقام الهواتف
    List<String> phones = [];
    if (json['phone_numbers'] is List) {
      phones = List<String>.from(json['phone_numbers']);
    } else if (json['phone_numbers'] is String) {
      phones = [json['phone_numbers']];
    }

    // معالجة المؤهلات
    List<Qualification> quals = [];
    if (json['qualifications'] != null) {
      quals = (json['qualifications'] as List)
          .map((q) => Qualification.fromJson(q))
          .toList();
    }

    return Teacher(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? 'male',
      phoneNumbers: phones,
      qualifications: quals,
      imageUrl: json['image_url'] ?? '',
    );
  }

  String getQualificationsText() {
    return qualifications
        .map((q) => q.name)
        .join(', ');
  }
}

class Qualification {
  final String name;
  final String authority;
  final String certification;
  final String date;

  Qualification({
    required this.name,
    required this.authority,
    required this.certification,
    required this.date,
  });

  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      name: json['name'] ?? '',
      authority: json['authority'] ?? '',
      certification: json['certification'] ?? '',
      date: json['date'] ?? '',
    );
  }
}