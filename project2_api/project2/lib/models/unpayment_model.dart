class UnpaidPayment {
  final int invoiceNumber;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String? dueDate;
  final int studentId;
  final int sessionId;

  UnpaidPayment({
    required this.invoiceNumber,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.dueDate,
    required this.studentId,
    required this.sessionId,
  });

  factory UnpaidPayment.fromJson(Map<String, dynamic> json) {
    return UnpaidPayment(
      invoiceNumber: json['invoice_number'],
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      remainingAmount: (json['remaining_amount'] ?? 0).toDouble(),
      dueDate: json['due_date'],
      studentId: json['student_id'],
      sessionId: json['session_id'],
    );
  }
}
