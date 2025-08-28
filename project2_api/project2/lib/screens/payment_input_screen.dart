// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/routes/app_routes.dart';
import 'package:project1/widgets/custom_app_bar.dart';
import 'package:project1/widgets/custom_bottom_nav.dart';

class PaymentInputScreen extends StatefulWidget {
  final int invoiceId; // تغيير من String إلى int
  final String invoiceNumber;
  final double amount;
  final String paymentDate;
  final String status;
  final int studentId;
  final int? sessionId;
  final double totalAmount;

  const PaymentInputScreen({
    super.key,
    required this.invoiceId,
    required this.invoiceNumber,
    required this.amount,
    required this.paymentDate,
    required this.status,
    required this.studentId,
    this.sessionId,
    required this.totalAmount,
  });

  @override
  State<PaymentInputScreen> createState() => _PaymentInputScreenState();
}

class _PaymentInputScreenState extends State<PaymentInputScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _generatedCode;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount.toStringAsFixed(2);
  }

  void _generatePaymentCode() {
    if (_amountController.text.isEmpty) {
      _showSnackBar('يرجى إدخال مبلغ السداد قبل الإرسال', Colors.red);
      return;
    }

    double enteredAmount = double.tryParse(_amountController.text) ?? 0;
    if (enteredAmount <= 0 || enteredAmount > widget.amount) {
      _showSnackBar('يرجى إدخال مبلغ صحيح بين 1 و ${widget.amount} ريال يمني', Colors.red);
      return;
    }

    setState(() {
      _generatedCode = (100000 + Random().nextInt(900000)).toString();
    });

    _showSnackBar('تم إنشاء رقم الحافظة بنجاح', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _clearInput() {
    setState(() {
      _amountController.clear();
    });
  }

  void _copyToClipboard() {
    if (_generatedCode != null) {
      Clipboard.setData(ClipboardData(text: _generatedCode!));
      _showSnackBar('تم نسخ رقم الحافظة', const Color(0xFF1C6DAD));
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'إدخال مبلغ السداد'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildInfoCard('رقم الفاتورة', widget.invoiceNumber, Icons.receipt),
            _buildInfoCard('المبلغ الإجمالي', '${widget.totalAmount.toStringAsFixed(2)} ر.س', Icons.attach_money),
            _buildInfoCard('المبلغ المتبقي', '${widget.amount.toStringAsFixed(2)} ر.س', Icons.money_off, color: Colors.redAccent),
            _buildInfoCard('تاريخ الاستحقاق', widget.paymentDate, Icons.date_range),
            _buildInfoCard(
              'حالة الفاتورة',
              widget.status == 'pending' ? 'غير مدفوعة' : 'مدفوعة',
              widget.status == 'pending' ? Icons.warning : Icons.check_circle,
              color: widget.status == 'pending' ? Colors.orange : Colors.green,
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'أدخل مبلغ السداد',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.payment, color: Color(0xFF1C6DAD)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: _clearInput,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generatePaymentCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C6DAD),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: Text(
                  'إرسال',
                  style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_generatedCode != null) ...[
              SizedBox(height: screenHeight * 0.04),
              Text(
                'رقم الحافظة للسداد عبر البريد:',
                style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _generatedCode!,
                      style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blue),
                      onPressed: _copyToClipboard,
                    ),
                  ],
                ),
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

  Widget _buildInfoCard(String title, String value, IconData icon, {Color color = const Color(0xFF1C6DAD)}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}