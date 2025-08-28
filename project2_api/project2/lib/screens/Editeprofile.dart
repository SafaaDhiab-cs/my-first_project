import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project1/models/studen_profile_model.dart';
import 'package:project1/widgets/custom_app_bar.dart';

class EditProfilePage extends StatefulWidget {
  final StudentProfile student;

  const EditProfilePage({Key? key, required this.student}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color(0xFF195F97);
  final Color _secondaryColor = const Color(0xFF195F97);
  

  late TextEditingController _fullNameController;
  late TextEditingController _englishNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.student.fullName);
    _englishNameController = TextEditingController(text: widget.student.englishName);
    _emailController = TextEditingController(text: widget.student.email);
    _phoneController = TextEditingController(text: widget.student.phone);
    _addressController = TextEditingController(text: widget.student.address);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _englishNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final response = await http.post(
      Uri.parse('http://192.168.0.250/api_inst/student_update.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': widget.student.id,
        'full_name': _fullNameController.text,
        'english_name': _englishNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
      }),
    );

    if (response.statusCode == 200) {
      final updatedStudent = StudentProfile(
        id: widget.student.id,
        userId: widget.student.userId,
        fullName: _fullNameController.text,
        englishName: _englishNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        image: widget.student.image,
        gender: widget.student.gender,
        birthDate: widget.student.birthDate,
        birthPlace: widget.student.birthPlace,
        qulification: widget.student.qulification,
        state: widget.student.state,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التعديلات بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, updatedStudent);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء حفظ التعديلات'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileImage(String? imagePath, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.25;
    
    if (imagePath == null || imagePath.isEmpty || imagePath == 'default.png') {
      return Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[200],
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(Icons.person, 
          color: Colors.white, 
          size: imageSize * 0.4,
        ),
      );
    }

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          imagePath.startsWith('http')
              ? imagePath
              : 'http://192.168.0.250/api_inst/uploads/$imagePath',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.blue[200],
              child: Icon(Icons.person, 
                color: Colors.white, 
                size: imageSize * 0.4,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final double spacing = isPortrait ? size.height * 0.02 : size.height * 0.01;
    final double textFieldFontSize = size.width * 0.04;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'تعديل الملف الشخصي'),
      ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                Center(
                  child: _buildProfileImage(widget.student.image, context),
                ),
                SizedBox(height: size.height * 0.02),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _fullNameController,
                          label: 'الاسم الكامل',
                          icon: Icons.person,
                          validator: true,
                          fontSize: textFieldFontSize,
                        ),
                        SizedBox(height: spacing),
                        _buildTextField(
                          controller: _englishNameController,
                          label: 'الاسم بالإنجليزية',
                          icon: Icons.translate,
                          fontSize: textFieldFontSize,
                        ),
                        SizedBox(height: spacing),
                        _buildTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          icon: Icons.email,
                          validator: true,
                          fontSize: textFieldFontSize,
                        ),
                        SizedBox(height: spacing),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'رقم الهاتف',
                          icon: Icons.phone,
                          validator: true,
                          fontSize: textFieldFontSize,
                        ),
                        SizedBox(height: spacing),
                        _buildTextField(
                          controller: _addressController,
                          label: 'العنوان',
                          icon: Icons.location_on,
                          fontSize: textFieldFontSize,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                SizedBox(
                  width: size.width * 0.7,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'حفظ التغييرات',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    double fontSize = 16,
    bool validator = false,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: fontSize),
        prefixIcon: Icon(icon, color: _secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15, 
          horizontal: 20,
        ),
      ),
      validator: validator
          ? (value) => value == null || value.isEmpty ? 'مطلوب' : null
          : null,
    );
  }
}