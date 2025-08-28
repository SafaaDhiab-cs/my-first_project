// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:project1/core/services/api_service.dart';
import 'package:project1/models/course_evaluation_model.dart';
import 'package:project1/widgets/custom_app_bar.dart';

class CourseRatingScreen extends StatefulWidget {
  final int studentId;

  const CourseRatingScreen({Key? key, required this.studentId})
      : super(key: key);

  @override
  _CourseRatingScreenState createState() => _CourseRatingScreenState();
}

class _CourseRatingScreenState extends State<CourseRatingScreen> {
  late Future<List<CourseEvaluation>> _completedCourses;
  final ApiService _apiService = ApiService('http://192.168.0.250/api_inst/');
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _completedCourses = _fetchCompletedCourses();
  }

  Future<List<CourseEvaluation>> _fetchCompletedCourses() async {
    try {
      return await _apiService.getCompletedCourses(widget.studentId);
    } catch (e) {
      throw Exception('فشل تحميل الدورات المكتملة: $e');
    }
  }

  Future<void> _submitRating(CourseEvaluation course) async {
    FocusScope.of(context).unfocus();

    if (course.rating < 1 || course.rating > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار تقييم بين 1 إلى 5 نجوم'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final response = await _apiService.submitCourseRating(
        studentId: widget.studentId,
        courseSessionId: course.courseSessionId,
        courseId: course.courseId,
        rating: course.rating,
        feedback: course.feedback,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(response['message'] ?? 'تم تقييم الدورة بنجاح! شكراً لك'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      setState(() {
        course.isRated = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Text(e.toString().replaceAll('Exception: ', '')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'تقييم الدورات المكتملة'),
      ),
      body: FutureBuilder<List<CourseEvaluation>>(
        future: _completedCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'حدث خطأ: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _completedCourses = _fetchCompletedCourses();
                      });
                    },
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 50, color: Colors.orange),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد دورات مكتملة لتقييمها',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final course = snapshot.data![index];
                return _buildCourseCard(course);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCourseCard(CourseEvaluation course) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              course.courseName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (course.isRated) ...[
              const Text(
                'تم تقييم هذه الدورة مسبقاً',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              StarRating(
                rating: course.rating,
                onRatingChanged: null,
              ),
              if (course.feedback.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'ملاحظاتك:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    course.feedback,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ] else ...[
              const Text(
                'قيم هذه الدورة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              StarRating(
                rating: course.rating,
                onRatingChanged: (newRating) {
                  setState(() {
                    course.rating = newRating;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'ملاحظاتك (اختياري)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'اكتب ملاحظاتك عن الدورة...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
                onChanged: (value) => course.feedback = value,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isSubmitting ? null : () => _submitRating(course),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'إرسال التقييم',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;

  const StarRating({
    Key? key,
    required this.rating,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber[700],
            size: 40,
          ),
          onPressed: onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        );
      }),
    );
  }
}
