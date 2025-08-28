<?php

header("Content-Type: application/json; charset=UTF-8");

include 'db.php';

$studentId = intval($_GET['student_id'] ?? 0);
$courseId = intval($_GET['course_id'] ?? 0);

try {
    // 1. الحصول على المبلغ الإجمالي من جدول الدفعات
    $totalAmountQuery = $conn->prepare("
        SELECT total_amount FROM payments 
        WHERE student_id = :studentId 
        AND course_id = :courseId
        ORDER BY created_at DESC LIMIT 1
    ");
    $totalAmountQuery->execute([':studentId' => $studentId, ':courseId' => $courseId]);
    $totalAmount = $totalAmountQuery->fetchColumn() ?? 0;

    // 2. جلب الفواتير المسددة مع المبلغ المدفوع
    $query = $conn->prepare("
        SELECT
            p.id AS payment_id,
            i.id AS invoice_id,
            i.invoice_number,
            i.amount AS paid_amount,
            i.paid_at AS payment_date,
            i.due_date,
            i.student_id,
            cs.course_id,
            c.course_name
        FROM invoices i
        JOIN payments p ON i.payment_id = p.id
        JOIN course_session_students css ON i.student_id = css.student_id
        JOIN course_sessions cs ON css.course_session_id = cs.id
        JOIN courses c ON cs.course_id = c.id
        WHERE i.student_id = :studentId
        AND cs.course_id = :courseId
        AND i.status = 1
        ORDER BY i.paid_at ASC
    ");
    $query->execute([':studentId' => $studentId, ':courseId' => $courseId]);
    $invoices = $query->fetchAll(PDO::FETCH_ASSOC);

    // 3. حساب المبالغ المتبقية والمطلوبة
    $cumulativePaid = 0;
    $remainingAmount = $totalAmount;
    $result = [];
    
    foreach ($invoices as $invoice) {
        $requiredAmount = $remainingAmount; // المبلغ المطلوب هو المتبقي قبل الدفع
        $paidAmount = $invoice['paid_amount'];
        $cumulativePaid += $paidAmount;
        $remainingAmount = $totalAmount - $cumulativePaid;
        
        $result[] = [
            'payment_id' => $invoice['payment_id'],
            'invoice_id' => $invoice['invoice_id'],
            'invoice_number' => $invoice['invoice_number'],
            'total_amount' => $totalAmount,
            'paid_amount' => $paidAmount,
            'required_amount' => $requiredAmount, // المبلغ المطلوب قبل الدفع
            'remaining_amount' => $remainingAmount, // المتبقي بعد الدفع
            'cumulative_paid' => $cumulativePaid,
            'payment_date' => $invoice['payment_date'],
            'due_date' => $invoice['due_date'],
            'student_id' => $invoice['student_id'],
            'course_id' => $invoice['course_id'],
            'course_name' => $invoice['course_name']
        ];
    }

    echo json_encode([
        'success' => true,
        'payments' => $result,
        'total_course_amount' => $totalAmount,
        'total_paid_amount' => $cumulativePaid,
        'remaining_amount' => $remainingAmount
    ]);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>