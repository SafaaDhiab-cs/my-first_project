// ignore_for_file: use_super_parameters, deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project1/models/studen_profile_model.dart';
import 'package:project1/screens/Editeprofile.dart';
import '../core/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final int studentId;

  const ProfilePage({Key? key, required this.studentId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<StudentProfile> _studentProfile;
  final ApiService _apiService = ApiService('http://192.168.0.250/api_inst/');

  @override
  void initState() {
    super.initState();
    _loadStudentProfile();
  }

  void _loadStudentProfile() {
    setState(() {
      _studentProfile = _apiService.fetchStudentProfile(widget.studentId);
    });
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
        ),
        child: Icon(Icons.person, color: Colors.white, size: imageSize * 0.4),
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
              : '${_apiService.baseUrl}uploads/$imagePath',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.blue[200],
              child: Icon(Icons.person,
                  color: Colors.white, size: imageSize * 0.4),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final student = await _studentProfile;
            if (student != null) {
              final updatedStudent = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(student: student),
                ),
              );
              if (updatedStudent != null) {
                _loadStudentProfile();
              }
            }
          },
          backgroundColor: Colors.blue[700],
          child: const Icon(Icons.edit, color: Colors.white),
        ),
        body: FutureBuilder<StudentProfile>(
          future: _studentProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('لا توجد بيانات لعرضها'));
            }

            final student = snapshot.data!;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  expandedHeight:
                      isPortrait ? size.height * 0.35 : size.height * 0.5,
                  pinned: true,
                  floating: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildProfileHeader(context, student),
                    centerTitle: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      children: [
                        _buildInfoCard(
                          context,
                          title: "معلومات التواصل",
                          icon: Icons.contact_mail_rounded,
                          items: [
                            _buildContactItem(Icons.phone_rounded, "الهاتف",
                                [student.phone], primaryColor, context),
                            _buildContactItem(
                                Icons.email_rounded,
                                "البريد الإلكتروني",
                                [student.email],
                                Colors.amber[700]!,
                                context),
                            _buildContactItem(
                                Icons.location_on_rounded,
                                "العنوان",
                                [student.address],
                                Colors.green[700]!,
                                context),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        _buildInfoCard(
                          context,
                          title: "معلومات شخصية",
                          icon: Icons.person_rounded,
                          items: [
                            _buildPersonalItem(
                                Icons.cake_rounded,
                                "تاريخ الميلاد",
                                student.birthDate,
                                Colors.purple[700]!,
                                context),
                            _buildPersonalItem(
                                Icons.place_rounded,
                                "مكان الميلاد",
                                student.birthPlace,
                                Colors.red[700]!,
                                context),
                            _buildPersonalItem(
                                Icons.school_rounded,
                                "المؤهل العلمي",
                                student.qulification,
                                Colors.orange[700]!,
                                context),
                            _buildPersonalItem(
                                Icons.transgender_rounded,
                                "الجنس",
                                student.gender,
                                Colors.teal[700]!,
                                context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, StudentProfile student) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF195F97),
                Color(0xFF2692E9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.2),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileImage(student.image, context),
                SizedBox(height: size.height * 0.01),
                Text(
                  student.fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                const Text(
                  "طالب",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                SizedBox(width: size.width * 0.02),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.02),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    List<String> values,
    Color color,
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.1,
            height: size.width * 0.1,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: size.width * 0.035,
                    )),
                ...values.map((v) => Padding(
                      padding: EdgeInsets.only(top: size.height * 0.005),
                      child: Text(
                        v.isNotEmpty ? v : 'غير متوفر',
                        style: TextStyle(
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPersonalItem(
    IconData icon,
    String title,
    String value,
    Color color,
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.1,
            height: size.width * 0.1,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: size.width * 0.035,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.005),
                  child: Text(
                    value.isNotEmpty ? value : 'غير متوفر',
                    style: TextStyle(
                      fontSize: size.width * 0.038,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
