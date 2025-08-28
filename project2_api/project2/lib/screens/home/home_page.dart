// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_bottom_nav.dart'; // تأكد من استيراد الـ CustomBottomNavBar
import '../../routes/app_routes.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: '',
          showInstituteName: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildGridMenu(context),
              const SizedBox(height: 10),
              _buildPromoCard(),
              const SizedBox(height: 20),
              _buildCarouselSlider(context),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 0, // حدد المؤشر المناسب لهذه الصفحة
          onItemTapped: (index) {
            // يمكنك استخدام AppRoutes أو التنقل مباشرة
            switch (index) {
              case 0:
                // الصفحة الحالية، لا تفعل شيئاً أو أعد تحميلها
                break;
              case 1:
                Navigator.pushNamed(context, AppRoutes.announcements);
                break;
              case 2:
                Navigator.pushNamed(context, AppRoutes.chatbot);
                break;
              case 3:
                Navigator.pushNamed(context, AppRoutes.aboutUs);
                break;
            }
          },
        ),
      ),
    );
  }

  // ... (بقية الدوال تبقى كما هي بدون تغيير)
  Widget _buildGridMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CustomIconButton(context, Icons.menu_book, "الدورات",
              const Color(0xFFe94e1b), AppRoutes.courses),
          CustomIconButton(context, Icons.article, "الإعلانات",
              const Color(0xFFff8c00), AppRoutes.announcements),
          CustomIconButton(context, Icons.people, "الطلاب",
              const Color(0xFFe94e1b), AppRoutes.login),
          CustomIconButton(context, Icons.person, "المدرسون",
              const Color(0xFFe94e1b), AppRoutes.teachers),
          CustomIconButton(context, Icons.person_outline, "معلومات عنا",
              const Color(0xFFe94e1b), AppRoutes.aboutUs),
        ],
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2F71A5), Color(0xFF7CB1DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معهد التعليم أولاً',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'رؤية جديدة ... تعليم أفضل',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Container(
                  height: 160,
                  width: 115,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/person1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.25,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: [
        "assets/images/a1.png",
        "assets/images/a2.png",
        "assets/images/a3.png",
        "assets/images/a4.png",
        "assets/images/a5.png",
      ].map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}