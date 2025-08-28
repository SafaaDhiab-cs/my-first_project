class LoginModel {
  final String email;
  final String password;
  final String role;

  LoginModel({
    required this.email,
    required this.password,
    this.role = 'student', // القيمة الافتراضية هي 'student'
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'role': role, // إرسال الدور مع البيانات
  };
}