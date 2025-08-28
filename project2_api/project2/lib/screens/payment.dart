// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:project1/routes/app_routes.dart';
import 'package:project1/screens/paid_payment.dart';
import 'package:project1/screens/unpaid_payment.dart';
import 'package:project1/widgets/custom_app_bar.dart';
import 'package:project1/widgets/custom_bottom_nav.dart';
import '../core/services/api_service.dart';
import '../models/get_studentcourse.dart';

class PaymentScreen extends StatefulWidget {
  final int studentId;

  const PaymentScreen({super.key, required this.studentId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _currentIndex = 0;
  StudentCourse? _selectedCourse;
  List<StudentCourse> _courses = [];
  bool _isLoading = true;
  bool _isProcessingPaid = false; // حالة تحميل خاصة بالمدفوعات المسددة
  bool _isProcessingUnpaid = false; // حالة تحميل خاصة بالمدفوعات غير المسددة
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudentCourses();
  }

  Future<void> _fetchStudentCourses() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final apiService = ApiService('http://192.168.0.250/api_inst/');
      final courses = await apiService.getStudentCourses(widget.studentId);

      setState(() {
        _courses = courses;
        if (_courses.isNotEmpty) {
          _selectedCourse = _courses.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل الدورات: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'الدفع'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchStudentCourses,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              )
            else if (_courses.isEmpty)
              const Center(
                child: Text(
                  'لا توجد دورات مسجلة',
                  style: TextStyle(fontSize: 18),
                ),
              )
            else ...[
              // Dropdown Menu
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: // ... (الكود الحالي يبقى كما هو مع إضافة هذا الجزء عند عرض تفاصيل الدورة)

                    DropdownButton<StudentCourse>(
                  value: _selectedCourse,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _courses.map((StudentCourse course) {
                    return DropdownMenuItem<StudentCourse>(
                      value: course,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(course.name,
                              style: const TextStyle(fontSize: 16)),
                          if (course.department != null)
                            Text(
                              course.department!,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (StudentCourse? newValue) {
                    setState(() {
                      _selectedCourse = newValue;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Payment Buttons
              PaymentButton(
                text: "المدفوعات المسددة",
                color1: Colors.blueAccent,
                color2: const Color(0xFF1C6DAD),
                icon: Icons.payment,
                isLoading: _isProcessingPaid,
                onPressed: () async {
                  if (_selectedCourse == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى اختيار دورة أولاً')),
                    );
                    return;
                  }

                  setState(() => _isProcessingPaid = true);
                  await Future.delayed(const Duration(milliseconds: 300));

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaidPaymentScreen(
                        studentId: widget.studentId,
                        courseId: _selectedCourse!.id,
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() => _isProcessingPaid = false);
                    }
                  });
                },
              ),

              const SizedBox(height: 20),

              PaymentButton(
                text: "المدفوعات غير المسددة",
                color1: Colors.orangeAccent,
                color2: Colors.deepOrange,
                icon: Icons.warning_amber_rounded,
                isLoading: _isProcessingUnpaid,
                onPressed: () async {
                  if (_selectedCourse == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى اختيار دورة أولاً')),
                    );
                    return;
                  }

                  setState(() => _isProcessingUnpaid = true);
                  await Future.delayed(const Duration(milliseconds: 300));

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnpaidPaymentScreen(
                        studentId: widget.studentId,
                        courseId: _selectedCourse!.id,
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() => _isProcessingUnpaid = false);
                    }
                  });
                },
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onPressed;

  const PaymentButton({
    super.key,
    required this.text,
    required this.color1,
    required this.color2,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color2.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
