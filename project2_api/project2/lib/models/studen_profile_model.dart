class StudentProfile {
  final int id;
  final int userId;
  final String fullName;
  final String englishName;
  final String image;
  final String phone;
  final String gender;
  final String qulification;
  final String birthDate;
  final String birthPlace;
  final String address;
  final String email;
  final String state;

  StudentProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.englishName,
    required this.image,
    required this.phone,
    required this.gender,
    required this.qulification,
    required this.birthDate,
    required this.birthPlace,
    required this.address,
    required this.email,
    required this.state,
  });

 factory StudentProfile.fromJson(Map<String, dynamic> json) {
  return StudentProfile(
    id: int.tryParse(json["id"].toString()) ?? 0,
    userId: int.tryParse(json["user_id"].toString()) ?? 0,
    fullName: json["full_name"]?.toString() ?? 'غير معروف',
    englishName: json["english_name"]?.toString() ?? '',
    image: json["image"]?.toString() ?? 'default.png',
    phone: json["phone"]?.toString() ?? 'غير مسجل',
    gender: json["gender"]?.toString() ?? 'غير محدد',
    qulification: json["qulification"]?.toString() ?? 'غير محدد',
    birthDate: json["birth_date"]?.toString() ?? 'غير محدد',
    birthPlace: json["birth_place"]?.toString() ?? 'غير معروف',
    address: json["address"]?.toString() ?? 'غير معروف',
    email: json["email"]?.toString() ?? 'لا يوجد',
    state: json["state"]?.toString() ?? 'غير محدد',
  );
}
}