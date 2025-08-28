import 'package:flutter/material.dart';
import 'package:project1/models/payment.dart';
import 'package:project1/screens/payment_input_screen.dart';
import '../core/services/api_service.dart';
import '../widgets/custom_app_bar.dart';

class UnpaidPaymentScreen extends StatefulWidget {
  final int studentId;
  final int courseId;

  const UnpaidPaymentScreen({
    Key? key,
    required this.studentId,
    required this.courseId,
  }) : super(key: key);

  @override
  _UnpaidPaymentScreenState createState() => _UnpaidPaymentScreenState();
}

class _UnpaidPaymentScreenState extends State<UnpaidPaymentScreen> {
  List<Payment> _payments = [];
  double _totalCourseAmount = 0;
  double _totalPaidAmount = 0;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUnpaidPayments();
  }

  Future<void> _fetchUnpaidPayments() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final apiService = ApiService('http://192.168.0.250/api_inst/');
      final payments = await apiService.getUnpaidPayments(
        widget.studentId,
        widget.courseId,
      );

      setState(() {
        _payments = payments;
        _totalCourseAmount = payments.fold(0, (sum, payment) => sum + payment.totalAmount);
        _totalPaidAmount = payments.fold(0, (sum, payment) => sum + payment.paidAmount);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل المدفوعات غير المسددة: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'المدفوعات غير المسددة'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 20),
              Text(_errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchUnpaidPayments,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_payments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: Colors.grey, size: 50),
            SizedBox(height: 20),
            Text('لا توجد مدفوعات غير مسددة'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchUnpaidPayments,
      child: Column(
        children: [
          _buildSummaryCard(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _payments.length,
              itemBuilder: (context, index) => _buildPaymentCard(_payments[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('المبلغ الإجمالي', '${_totalCourseAmount.toStringAsFixed(2)} ر.س'),
            _buildSummaryRow('المبلغ المدفوع', '${_totalPaidAmount.toStringAsFixed(2)} ر.س'),
            _buildSummaryRow('المبلغ المتبقي', '${(_totalCourseAmount - _totalPaidAmount).toStringAsFixed(2)} ر.س'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'فاتورة ${payment.invoiceNumber}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'غير مسدد',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            _buildDetailRow('المبلغ المطلوب', '${payment.totalAmount.toStringAsFixed(2)} ر.س'),
            _buildDetailRow('المبلغ المدفوع', '${payment.paidAmount.toStringAsFixed(2)} ر.س'),
            _buildDetailRow('المبلغ المتبقي', '${payment.remainingAmount.toStringAsFixed(2)} ر.س'),
            if (payment.dueDate != null)
              _buildDetailRow('تاريخ الاستحقاق', payment.dueDate!),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentInputScreen(
                        invoiceId: payment.invoiceId,
                        invoiceNumber: payment.invoiceNumber,
                        amount: payment.remainingAmount,
                        paymentDate: payment.dueDate ?? 'غير محدد',
                        status: 'pending',
                        studentId: payment.studentId,
                        sessionId: payment.sessionId,
                        totalAmount: payment.totalAmount,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C6DAD),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ادفع الآن',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }
}