// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:project1/widgets/custom_app_bar.dart';
import '../widgets/star_rating.dart';
import '../widgets/feedback_input.dart';

class Teacher {
  final String courseName;
  final String teacherName;
  final bool isCompleted;
  double rating;
  final TextEditingController feedbackController;
  bool hasRated;

  Teacher({
    required this.courseName,
    required this.teacherName,
    required this.isCompleted,
    this.rating = 0,
    TextEditingController? feedbackController,
    this.hasRated = false,
  }) : feedbackController = feedbackController ?? TextEditingController();
}

class TeacherRatingScreen extends StatefulWidget {
  const TeacherRatingScreen({super.key});

  @override
  _TeacherRatingScreenState createState() => _TeacherRatingScreenState();
}

class _TeacherRatingScreenState extends State<TeacherRatingScreen> {
  late List<Teacher> teachers;

  @override
  void initState() {
    super.initState();
    teachers = [
      Teacher(
        courseName: 'مادة الرياضيات',
        teacherName: 'أحمد محمد',
        isCompleted: true,
      ),
      Teacher(
        courseName: 'مادة الإنجليزية',
        teacherName: 'سمية علي',
        isCompleted: true,
      ),
      Teacher(
        courseName: 'مادة الفيزياء',
        teacherName: 'خالد عبدالله',
        isCompleted: false,
      ),
    ];
  }

  @override
  void dispose() {
    for (var teacher in teachers) {
      teacher.feedbackController.dispose();
    }
    super.dispose();
  }

  void _submitRating(int index) {
    final teacher = teachers[index];
    
    if (!teacher.isCompleted) {
      _showSnackbar("لا يمكن التقييم قبل إكمال الكورس", Colors.red);
      return;
    }
    if (teacher.rating == 0) {
      _showSnackbar("يرجى اختيار تقييم قبل الإرسال.", Colors.red);
      return;
    }
    if (teacher.feedbackController.text.trim().isEmpty) {
      _showSnackbar("يرجى إدخال ملاحظاتك قبل الإرسال.", Colors.red);
      return;
    }

    setState(() {
      teacher.hasRated = true;
    });

    _showSnackbar("تم إرسال التقييم بنجاح! شكرًا لمساهمتك.", Colors.green);
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildTeacherCard(Teacher teacher, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Text(
              'اسم المعلم: ${teacher.teacherName}',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'المادة: ${teacher.courseName}',
              style: const TextStyle(fontSize: 20),
            ),
            
            if (!teacher.isCompleted) ...[
              const SizedBox(height: 20),
              const Text(
                'سيصبح التقييم متاحًا بعد إكمال الكورس',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
            
            if (teacher.isCompleted) ...[
              const SizedBox(height: 20),
              const Text(
                'تقييم المعلم:',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StarRating(
                rating: teacher.rating,
                color: teacher.hasRated
                    ? Colors.blue
                    : Colors.amber,
                onRatingChanged: teacher.hasRated
                    ? null
                    : (newRating) {
                        setState(() {
                          teacher.rating = newRating;
                        });
                      },
              ),
              const SizedBox(height: 20),
              const Text(
                'ملاحظاتك:',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FeedbackInput(
                controller: teacher.feedbackController,
                hintText: 'اكتب ملاحظاتك عن المعلم هنا...',
                enabled: !teacher.hasRated,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: teacher.hasRated || teacher.rating == 0
                    ? null
                    : () => _submitRating(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: teacher.hasRated || teacher.rating == 0
                      ? Colors.grey
                      : Colors.orange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'إرسال التقييم',
                  style: TextStyle(
                      fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Teacher> completedTeachers = teachers.where((t) => t.isCompleted).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CustomAppBar(title: 'تقييم المدرسين'),
        ),
        body: Center(
          child: completedTeachers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'لا يمكنك تقييم المدرسين حاليًا. يجب إنهاء الدورة قبل التقييم.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    return _buildTeacherCard(teachers[index], index);
                  },
                ),
        ),
      ),
    );
  }
}