class ChangePasswordModel {
  final int userId;
  final String oldPassword;
  final String newPassword;

  ChangePasswordModel({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'old_password': oldPassword,
        'new_password': newPassword,
      };
}