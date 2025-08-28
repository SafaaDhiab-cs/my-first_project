// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../core/services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../models/announcement_model.dart';

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  late ApiService apiService;
  List<Announcement> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService("http://192.168.0.250/api_inst/");
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Announcement> fetchedAnnouncements =
          await apiService.fetchAnnouncements();
      setState(() {
        announcements = fetchedAnnouncements;
        isLoading = false;
      });
    } catch (e) {
      print("خطأ في تحميل الإعلانات: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الاعلانات'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                if (announcements.any((a) => a.image != null))
                  CarouselSlider(
                    items: announcements
                        .where((a) => a.image != null)
                        .map((announcement) =>
                            _buildImageItem(announcement, context))
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.9,
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      return _buildAnnouncementItem(
                          announcements[index], context);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildImageItem(Announcement announcement, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Card(
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            announcement.image!,
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight * 0.25,
            errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                size: screenWidth * 0.2,
                color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementItem(
      Announcement announcement, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  announcement.image!,
                  fit: BoxFit.cover,
                  width: screenWidth,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                announcement.content,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📅 بداية: ${announcement.startDate ?? "غير محدد"}',
                    style: TextStyle(
                        color: Colors.blueGrey, fontSize: screenWidth * 0.035),
                  ),
                  Text(
                    '📅 نهاية: ${announcement.endDate ?? "غير محدد"}',
                    style: TextStyle(
                        color: Colors.redAccent, fontSize: screenWidth * 0.035),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
