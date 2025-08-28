<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db.php';

$studentId = intval($_GET['student_id'] ?? 0);
$courseId = intval($_GET['course_id'] ?? 0);

try {
    // 1. الحصول على سعر الدورة الكلي
    $coursePriceQuery = $conn->prepare("
        SELECT price FROM course_prices 
        WHERE course_id = :courseId 
        ORDER BY date DESC LIMIT 1
    ");
    $coursePriceQuery->execute([':courseId' => $courseId]);
    $totalAmount = $coursePriceQuery->fetchColumn() ?? 0;

    // 2. حساب المبلغ المدفوع حتى الآن
    $paidAmountQuery = $conn->prepare("
        SELECT COALESCE(SUM(i.amount), 0) 
        FROM invoices i
        JOIN course_session_students css ON i.student_id = css.student_id
        JOIN course_sessions cs ON css.course_session_id = cs.id
        WHERE i.student_id = :studentId
        AND cs.course_id = :courseId
        AND i.status = 1
    ");
    $paidAmountQuery->execute([':studentId' => $studentId, ':courseId' => $courseId]);
    $paidAmount = $paidAmountQuery->fetchColumn();

    // 3. جلب الفواتير غير المسددة
    $query = $conn->prepare("
        SELECT 
            p.id AS payment_id,
            i.id AS invoice_id,
            i.invoice_number,
            i.amount AS required_amount,
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
        AND i.status = 0
        ORDER BY i.due_date ASC
    ");
    $query->execute([':studentId' => $studentId, ':courseId' => $courseId]);
    $invoices = $query->fetchAll(PDO::FETCH_ASSOC);

    // 4. إعداد النتيجة
    $result = [];
    foreach ($invoices as $invoice) {
        $result[] = [
            'payment_id' => $invoice['payment_id'],
            'invoice_id' => $invoice['invoice_id'],
            'invoice_number' => $invoice['invoice_number'],
            'total_amount' => $totalAmount,
            'paid_amount' => $invoice['required_amount'],
            'cumulative_paid' => $paidAmount,
            'payment_date' => null,
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
        'total_paid_amount' => $paidAmount
    ]);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>