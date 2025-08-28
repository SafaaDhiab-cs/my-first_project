class PaymentInvoice {
  final int id;
  final String invoiceNumber;
  final double amount;
  final String paymentDate;
  final String status;
  final int studentId;
  final int? sessionId;
  final double totalAmount;

  PaymentInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.amount,
    required this.paymentDate,
    required this.status,
    required this.studentId,
    this.sessionId,
    required this.totalAmount,
  });

  factory PaymentInvoice.fromJson(Map<String, dynamic> json) {
    return PaymentInvoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      amount: double.parse(json['amount'].toString()),
      paymentDate: json['payment_date'],
      status: json['status'],
      studentId: json['student_id'],
      sessionId: json['session_id'],
      totalAmount: double.parse(json['total_amount'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'amount': amount,
      'payment_date': paymentDate,
      'status': status,
      'student_id': studentId,
      'session_id': sessionId,
      'total_amount': totalAmount,
    };
  }
}