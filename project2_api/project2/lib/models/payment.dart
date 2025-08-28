class Payment {
  final int invoiceId;
  final String invoiceNumber;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String? paymentDate;
  final String? dueDate;
  final int studentId;
  final int? sessionId;
  final String? courseName;

  Payment({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.totalAmount,
    required this.paidAmount,
    this.paymentDate,
    this.dueDate,
    required this.studentId,
    this.sessionId,
    this.courseName,
  }) : remainingAmount = totalAmount - paidAmount;

  factory Payment.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة لتحويل القيم إلى double
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    // دالة مساعدة لتحويل القيم إلى int
    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return Payment(
      invoiceId: parseInt(json['invoice_id']),
      invoiceNumber: json['invoice_number']?.toString() ?? 'N/A',
      totalAmount: parseDouble(json['total_amount']),
      paidAmount: parseDouble(json['paid_amount']),
      paymentDate: json['payment_date']?.toString(),
      dueDate: json['due_date']?.toString(),
      studentId: parseInt(json['student_id']),
      sessionId: json['session_id'] != null ? parseInt(json['session_id']) : null,
      courseName: json['course_name']?.toString(),
    );
  }
}