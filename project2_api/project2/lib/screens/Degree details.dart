// ignore_for_file: file_names, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:project1/models/current_course_model.dart';
import 'package:project1/widgets/custom_app_bar.dart';

class DegreeDetails extends StatelessWidget {
  final Course1 course;

  const DegreeDetails({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'تفاصيل الدرجات'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context),
            _buildGradeSummary(context),
            _buildDetailedGrades(context),
            _buildProgressSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double fontSizeTitle = width * 0.06;
        double fontSizeSub = width * 0.045;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2692E9), // اللون الفاتح - سيكون جهة اليمين
                Color(0xFF195F97), // اللون الغامق - سيكون جهة اليسار
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                course.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                course.category,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSizeSub,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              _buildTotalScoreCard(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalScoreCard(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            Text(
              'المجموع الكلي',
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.totalDegree.toStringAsFixed(2),
              style: TextStyle(
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            _buildGradeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeIndicator() {
    double percentage = course.totalDegree / 100;
    Color progressColor = percentage >= 0.7
        ? Colors.green
        : percentage >= 0.5
            ? Colors.orange
            : Colors.red;

    return Column(
      children: [
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        const SizedBox(height: 8),
        Text(
          '${(percentage * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: progressColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeSummary(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الدرجات',
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGradeItem(
                  'العملي', course.practicalDegree, Colors.blue, width),
              _buildGradeItem(
                  'النهائي', course.finalDegree, Colors.green, width),
              _buildGradeItem(
                  'الحضور', course.attendanceDegree, Colors.purple, width),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(
      String title, double value, Color color, double width) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDetailedGrades(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            children: [
              _buildGradeDetailRow(
                  'الدرجة العملية', course.practicalDegree, 30),
              const Divider(),
              _buildGradeDetailRow('الدرجة النهائية', course.finalDegree, 50),
              const Divider(),
              _buildGradeDetailRow('درجة الحضور', course.attendanceDegree, 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeDetailRow(String title, double achieved, int max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${achieved.toStringAsFixed(2)}/$max',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: achieved / max,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقدم الطالب',
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildComparisonItem(' الدرجة العظمي', '100.00', Colors.green),
                const SizedBox(height: 12),
                _buildComparisonItem('متوسط الدرجة', '78.00', Colors.blue),
                const SizedBox(height: 12),
                _buildComparisonItem('درجتك',
                    course.totalDegree.toStringAsFixed(2), Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
