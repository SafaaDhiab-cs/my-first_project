<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

require_once 'db.php';

// التحقق من التوكن الأساسي (اختياري)
$validToken = "YOUR_SECURE_TOKEN";
$headers = getallheaders();
if (!isset($headers['Authorization']) || $headers['Authorization'] !== $validToken) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Unauthorized access"]);
    exit;
}

$action = $_GET['action'] ?? '';
$input = json_decode(file_get_contents('php://input'), true);

try {
    switch ($action) {
        case 'get_student_courses':
            requireParams(['student_id']);
            getStudentCourses(intval($_GET['student_id']));
            break;
            
        case 'get_paid_payments':
            requireParams(['student_id', 'course_id']);
            getPaidPayments(intval($_GET['student_id']), intval($_GET['course_id']));
            break;
            
        case 'get_unpaid_payments':
            requireParams(['student_id', 'course_id']);
            getUnpaidPayments(intval($_GET['student_id']), intval($_GET['course_id']));
            break;
            
        case 'process_payment':
            requireParams(['student_id', 'invoice_id', 'amount', 'payment_code'], $input);
            processPayment(
                intval($input['student_id']),
                intval($input['invoice_id']),
                floatval($input['amount']),
                $input['payment_code']
            );
            break;
            
        default:
            throw new Exception("Invalid action");
    }
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}

// الدوال المساعدة
function requireParams($params, $data = null) {
    $source = $data ?? $_GET;
    foreach ($params as $param) {
        if (!isset($source[$param]) || empty($source[$param])) {
            throw new Exception("Missing parameter: $param");
        }
    }
}

// الدوال الرئيسية
function getStudentCourses($studentId) {
    global $conn;
    
    $stmt = $conn->prepare("
        SELECT cs.id, c.course_name, d.department_name 
        FROM course_session_students css
        JOIN course_sessions cs ON css.course_session_id = cs.id
        JOIN courses c ON cs.course_id = c.id
        JOIN departments d ON c.department_id = d.id
        WHERE css.student_id = ?
        
        UNION
        
        SELECT c.id, c.course_name, d.department_name 
        FROM course_students cs
        JOIN courses c ON cs.course_id = c.id
        JOIN departments d ON c.department_id = d.id
        WHERE cs.student_id = ? AND cs.status = 'waiting'
    ");
    $stmt->execute([$studentId, $studentId]);
    
    $courses = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        "success" => true,
        "courses" => $courses
    ]);
}

function getPaidPayments($studentId, $courseId) {
    global $conn;
    
    $stmt = $conn->prepare("
        SELECT i.id as invoice_id, i.invoice_number, i.amount, 
               DATE_FORMAT(i.paid_at, '%Y-%m-%d') as payment_date, 
               'completed' as status,
               c.course_name
        FROM invoices i
        JOIN course_session_students css ON i.student_id = css.student_id
        JOIN course_sessions cs ON css.course_session_id = cs.id
        JOIN courses c ON cs.course_id = c.id
        WHERE i.student_id = ? AND cs.course_id = ? AND i.status = 1
        
        UNION
        
        SELECT i.id as invoice_id, i.invoice_number, i.amount, 
               DATE_FORMAT(i.paid_at, '%Y-%m-%d') as payment_date, 
               'pending' as status,
               c.course_name
        FROM invoices i
        JOIN course_students cs ON i.student_id = cs.student_id
        JOIN courses c ON cs.course_id = c.id
        WHERE i.student_id = ? AND c.id = ? AND i.status = 1
    ");
    $stmt->execute([$studentId, $courseId, $studentId, $courseId]);
    
    $payments = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        "success" => true,
        "payments" => $payments
    ]);
}

function getUnpaidPayments($studentId, $courseId) {
    global $conn;
    
    $stmt = $conn->prepare("
        SELECT i.id as invoice_id, i.invoice_number, i.amount, 
               DATE_FORMAT(i.due_date, '%Y-%m-%d') as payment_date,
               c.course_name
        FROM invoices i
        JOIN course_session_students css ON i.student_id = css.student_id
        JOIN course_sessions cs ON css.course_session_id = cs.id
        JOIN courses c ON cs.course_id = c.id
        WHERE i.student_id = ? AND cs.course_id = ? AND i.status = 0
        
        UNION
        
        SELECT i.id as invoice_id, i.invoice_number, i.amount, 
               DATE_FORMAT(i.due_date, '%Y-%m-%d') as payment_date,
               c.course_name
        FROM invoices i
        JOIN course_students cs ON i.student_id = cs.student_id
        JOIN courses c ON cs.course_id = c.id
        WHERE i.student_id = ? AND c.id = ? AND i.status = 0
    ");
    $stmt->execute([$studentId, $courseId, $studentId, $courseId]);
    
    $payments = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        "success" => true,
        "payments" => $payments
    ]);
}

function processPayment($studentId, $invoiceId, $amount, $paymentCode) {
    global $conn;
    
    $conn->beginTransaction();
    
    try {
        // التحقق من صحة الفاتورة
        $stmt = $conn->prepare("
            SELECT amount FROM invoices 
            WHERE id = ? AND student_id = ? AND status = 0
        ");
        $stmt->execute([$invoiceId, $studentId]);
        $invoice = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$invoice) {
            throw new Exception("Invoice not found or already paid");
        }
        
        // التحقق من أن المبلغ المسدد مناسب
        if ($amount > $invoice['amount']) {
            throw new Exception("المبلغ المدفوع أكبر من المطلوب");
        }
        
        // تحديث حالة الفاتورة
        $stmt = $conn->prepare("
            UPDATE invoices 
            SET status = 1, 
                paid_at = NOW(),
                payment_code = ?
            WHERE id = ?
        ");
        $stmt->execute([$paymentCode, $invoiceId]);
        
        // تسجيل عملية الدفع
        $stmt = $conn->prepare("
            INSERT INTO payments 
            (student_id, invoice_id, status, payment_date, amount, payment_code) 
            VALUES (?, ?, 'completed', NOW(), ?, ?)
        ");
        $stmt->execute([$studentId, $invoiceId, $amount, $paymentCode]);
        
        $conn->commit();
        
        echo json_encode([
            "success" => true,
            "message" => "تمت عملية الدفع بنجاح",
            "payment_code" => $paymentCode
        ]);
        
    } catch (Exception $e) {
        $conn->rollBack();
        throw new Exception($e->getMessage());
    }
}
?>