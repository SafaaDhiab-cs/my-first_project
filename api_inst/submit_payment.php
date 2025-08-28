<?php
header("Content-Type: application/json");
require_once 'db.php';

// تمكين تسجيل الأخطاء
error_reporting(E_ALL);
ini_set('display_errors', 1);

// زيادة وقت تنفيذ السكربت إلى 60 ثانية
set_time_limit(60);

// إنشاء مسار مطلق لملف السجلات
$logFile = __DIR__ . '/payment_errors.log';
file_put_contents($logFile, "\n" . date('Y-m-d H:i:s') . " - بدء عملية جديدة\n", FILE_APPEND);

// تعطيل تخزين المؤقت لضمان أحدث البيانات
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Sat, 26 Jul 1997 05:00:00 GMT");

$response = ['status' => 'error', 'message' => 'حدث خطأ غير متوقع'];

try {
    // التحقق من طريقة الطلب
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception("يجب استخدام طريقة POST", 405);
    }

    // قراءة وتحليل بيانات الإدخال
    $jsonInput = file_get_contents('php://input');
    $input = json_decode($jsonInput, true);
    
    file_put_contents($logFile, "البيانات الخام المستلمة:\n" . $jsonInput . "\n", FILE_APPEND);

    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("بيانات JSON غير صالحة: " . json_last_error_msg(), 400);
    }

    // التحقق من الحقول المطلوبة
    $requiredFields = [
        'student_id' => 'معرف الطالب',
        'invoice_id' => 'معرف الفاتورة', 
        'amount' => 'المبلغ',
        'payment_date' => 'تاريخ الدفع'
    ];
    
    foreach ($requiredFields as $field => $fieldName) {
        if (!isset($input[$field])) {
            throw new Exception("حقل {$fieldName} مطلوب", 400);
        }
    }

    // تحويل البيانات مع التحقق من الصحة
    $studentId = filter_var($input['student_id'], FILTER_VALIDATE_INT);
    $invoiceId = filter_var($input['invoice_id'], FILTER_VALIDATE_INT);
    $amount = filter_var($input['amount'], FILTER_VALIDATE_FLOAT);
    
    $timestamp = strtotime($input['payment_date']);
    if ($timestamp === false) {
        throw new Exception("تاريخ الدفع غير صالح", 400);
    }
    $paymentDate = date('Y-m-d H:i:s', $timestamp);

    $sessionId = isset($input['session_id']) ? filter_var($input['session_id'], FILTER_VALIDATE_INT) : null;
    $totalAmount = isset($input['total_amount']) ? filter_var($input['total_amount'], FILTER_VALIDATE_FLOAT) : $amount;

    if ($studentId === false || $studentId <= 0) {
        throw new Exception("معرف الطالب يجب أن يكون رقماً صحيحاً موجباً", 400);
    }
    if ($invoiceId === false || $invoiceId <= 0) {
        throw new Exception("معرف الفاتورة يجب أن يكون رقماً صحيحاً موجباً", 400);
    }
    if ($amount === false || $amount <= 0) {
        throw new Exception("المبلغ يجب أن يكون رقماً موجباً", 400);
    }

    // بدء المعاملة
    $conn->beginTransaction();
    file_put_contents($logFile, "بدء المعاملة\n", FILE_APPEND);

    try {
        // ========== التحقق من هيكل الجداول ==========
        $tablesToCheck = ['invoices', 'payments', 'course_session_students'];
        $tableColumns = [];
        
        foreach ($tablesToCheck as $table) {
            $stmt = $conn->prepare("SHOW COLUMNS FROM $table");
            $stmt->execute();
            $tableColumns[$table] = $stmt->fetchAll(PDO::FETCH_COLUMN);
            file_put_contents($logFile, "أعمدة جدول $table: " . implode(', ', $tableColumns[$table]) . "\n", FILE_APPEND);
        }

        // ========== معالجة الفاتورة ==========
        $amountColumn = in_array('amount', $tableColumns['invoices']) ? 'amount' : 
                       (in_array('total_amount', $tableColumns['invoices']) ? 'total_amount' : null);
        
        if (!$amountColumn) {
            throw new Exception("لا يوجد عمود للمبلغ في جدول الفواتير", 500);
        }

        // التحقق من وجود الفاتورة
        $stmt = $conn->prepare("SELECT id, status, $amountColumn as amount FROM invoices WHERE id = ? AND student_id = ? FOR UPDATE");
        $stmt->execute([$invoiceId, $studentId]);
        $invoice = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$invoice) {
            throw new Exception("الفاتورة غير موجودة أو لا تنتمي لهذا الطالب", 404);
        }

        if ($invoice['status'] == 'paid') {
            throw new Exception("تم دفع هذه الفاتورة مسبقاً", 400);
        }

        // إنشاء رقم فاتورة فريد
        $invoiceNumber = 'INV-' . time() . '-' . bin2hex(random_bytes(4));

        // تحديث الفاتورة
        $updateInvoiceQuery = "UPDATE invoices SET 
            $amountColumn = :amount, 
            status = 'paid', 
            paid_at = :paymentDate, 
            invoice_number = :invoiceNumber, 
            updated_at = NOW()
            WHERE id = :invoiceId";
        
        $stmt = $conn->prepare($updateInvoiceQuery);
        $stmt->execute([
            ':amount' => $amount,
            ':paymentDate' => $paymentDate,
            ':invoiceNumber' => $invoiceNumber,
            ':invoiceId' => $invoiceId
        ]);
        file_put_contents($logFile, "تم تحديث الفاتورة\n", FILE_APPEND);

        // ========== تسجيل الدفع ==========
        $paymentFields = [
            'student_id' => $studentId,
            'invoice_id' => $invoiceId,
            'amount' => $amount,
            'payment_date' => $paymentDate,
            'total_amount' => $totalAmount
        ];
        
        if ($sessionId !== null && in_array('session_id', $tableColumns['payments'])) {
            $paymentFields['session_id'] = $sessionId;
        }

        // بناء استعلام INSERT ديناميكي
        $paymentColumns = array_keys($paymentFields);
        $paymentValues = array_values($paymentFields);
        
        $placeholders = implode(', ', array_fill(0, count($paymentColumns), '?'));
        $columnsStr = implode(', ', $paymentColumns);
        
        $insertPaymentQuery = "INSERT INTO payments ($columnsStr, created_at) VALUES ($placeholders, NOW())";
        
        $stmt = $conn->prepare($insertPaymentQuery);
        $stmt->execute($paymentValues);

        $paymentId = $conn->lastInsertId();
        file_put_contents($logFile, "تم تسجيل الدفع - ID: $paymentId\n", FILE_APPEND);

        // ========== تحديث حالة الجلسة ==========
        if ($sessionId !== null && in_array('status', $tableColumns['course_session_students'])) {
            $stmt = $conn->prepare("
                UPDATE course_session_students 
                SET status = 'active', updated_at = NOW()
                WHERE student_id = ? AND course_session_id = ? AND status != 'active'
            ");
            $stmt->execute([$studentId, $sessionId]);
            file_put_contents($logFile, "تم تحديث حالة الجلسة\n", FILE_APPEND);
        }

        $conn->commit();
        file_put_contents($logFile, "تم تأكيد المعاملة بنجاح\n", FILE_APPEND);

        $response = [
            'status' => 'success',
            'message' => 'تم تسجيل الدفع بنجاح',
            'payment_id' => $paymentId,
            'invoice_number' => $invoiceNumber,
            'total_paid' => $totalAmount,
            'timestamp' => date('Y-m-d H:i:s')
        ];

    } catch (PDOException $e) {
        $conn->rollBack();
        $errorMsg = "خطأ في قاعدة البيانات: " . $e->getMessage();
        file_put_contents($logFile, "خطأ في المعاملة: $errorMsg\n", FILE_APPEND);
        throw new Exception($errorMsg, 500);
    }

} catch (Exception $e) {
    http_response_code($e->getCode() ?: 500);
    $response = [
        'status' => 'error',
        'message' => $e->getMessage(),
        'error_code' => $e->getCode(),
        'timestamp' => date('Y-m-d H:i:s')
    ];
    file_put_contents($logFile, "خطأ نهائي: " . $e->getMessage() . "\n", FILE_APPEND);
}

// إرسال الرد النهائي
file_put_contents($logFile, "الرد النهائي: " . json_encode($response, JSON_UNESCAPED_UNICODE) . "\n", FILE_APPEND);
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
?>