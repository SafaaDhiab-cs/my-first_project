// ignore_for_file: deprecated_member_use, use_super_parameters, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // إضافة المكتبة

import '../core/services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../models/institute.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({Key? key}) : super(key: key);

  @override
  _AboutusState createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  int _currentIndex = 3;
  late Future<Institute> institute;

  // رابط صفحة التسجيل في الموقع
  final String registrationUrl =
      'http://192.168.0.250/register'; // ضع الرابط الفعلي هنا

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/announcements');
        break;
      case 2:
        Navigator.pushNamed(context, '/chatbot');
        break;
      case 3:
        Navigator.pushNamed(context, '/about_us');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    final ApiService apiService = ApiService('http://192.168.0.250/api_inst/');
    institute = apiService.fetchInstitute();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'معهد التعليم أولاً'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<Institute>(
          future: institute,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('خطأ: ${snapshot.error}'));
            } else {
              final instituteData = snapshot.data!;
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF195F97),
                      Color(0xFF2692E9),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.015),

                    // صورة ثابتة من assets
                    Center(
                      child: CircleAvatar(
                        radius: screenWidth * 0.14,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            const AssetImage('assets/images/logo.png'),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.012),

                    Text(
                      instituteData.instituteName,
                      style: TextStyle(
                        fontSize: screenWidth * 0.048,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04),
                        child: Column(
                          children: [
                            Text(
                              instituteData.instituteDescription,
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              instituteData.aboutUs,
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.white,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Column(
                              children: [
                                ContactRow(
                                    icon: Icons.call,
                                    text: instituteData.phone),
                                ContactRow(
                                    icon: Icons.email,
                                    text: instituteData.email),
                                ContactRow(
                                    icon: Icons.location_on,
                                    text: instituteData.address),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.025),

                            // زر "سجل الآن!"
                            ElevatedButton(
                              onPressed: () async {
                                // عند الضغط على الزر، سيتم فتح صفحة التسجيل في المتصفح
                                if (await canLaunch("registrationUrl")) {
                                  await launch(
                                      registrationUrl); // فتح الرابط في المتصفح
                                } else {
                                  throw 'لا يمكن فتح الرابط $registrationUrl';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 130, 54),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.08,
                                  vertical: screenHeight * 0.016,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'سجل الآن!',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactRow({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 244, 130, 54)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
