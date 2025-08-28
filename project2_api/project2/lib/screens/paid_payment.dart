import 'package:flutter/material.dart';
import 'package:project1/models/payment.dart';
import '../core/services/api_service.dart';
import '../widgets/custom_app_bar.dart';

class PaidPaymentScreen extends StatefulWidget {
  final int studentId;
  final int courseId;

  const PaidPaymentScreen({
    super.key,
    required this.studentId,
    required this.courseId,
  });

  @override
  _PaidPaymentScreenState createState() => _PaidPaymentScreenState();
}

class _PaidPaymentScreenState extends State<PaidPaymentScreen> {
  List<Payment> _payments = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPaidPayments();
  }

  Future<void> _fetchPaidPayments() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final apiService = ApiService('http://192.168.0.250/api_inst/');
      final payments = await apiService.getPaidPayments(
        widget.studentId,
        widget.courseId,
      );

      setState(() {
        _payments = payments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل المدفوعات: ${e.toString().replaceAll('Exception: ', '')}';
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
        child: CustomAppBar(title: 'المدفوعات المسددة'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    double screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: screenWidth * 0.15),
              SizedBox(height: screenWidth * 0.05),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenWidth * 0.05),
              ElevatedButton(
                onPressed: _fetchPaidPayments,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: Colors.grey, size: screenWidth * 0.15),
            SizedBox(height: screenWidth * 0.05),
            Text(
              'لا توجد مدفوعات مسددة',
              style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPaidPayments,
      child: ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          return _buildPaymentCard(_payments[index], index);
        },
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'فاتورة ${payment.invoiceNumber}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'مسدد',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: screenWidth * 0.08, thickness: 1),
            _buildDetailRow('المبلغ المطلوب', '${payment.totalAmount.toStringAsFixed(2)} ر.س', screenWidth),
            _buildDetailRow('المبلغ المدفوع', '${payment.paidAmount.toStringAsFixed(2)} ر.س', screenWidth),
            if (payment.paymentDate != null)
              _buildDetailRow('تاريخ الدفع', payment.paymentDate!, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
        ],
      ),
    );
  }
}