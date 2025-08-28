class Institute {
  final String instituteName; // جديد
  final String instituteDescription; // كان description سابقاً
  final String phone;
  final String email;
  final String address;
  final String aboutUs;
  final String? aboutImage; // كان logoUrl سابقاً

  Institute({
    required this.instituteName,
    required this.instituteDescription,
    required this.phone,
    required this.email,
    required this.address,
    required this.aboutUs,
    this.aboutImage,
  });

  factory Institute.fromJson(Map<String, dynamic> json) {
    return Institute(
      instituteName: json['institute_name'] ?? '',
      instituteDescription: json['institute_description'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      aboutUs: json['about_us'] ?? '',
      aboutImage: json['about_image'],
    );
  }
}