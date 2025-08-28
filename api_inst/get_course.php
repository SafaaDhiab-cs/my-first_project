<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db.php'; // تضمين ملف الاتصال

// تفعيل عرض الأخطاء
error_reporting(E_ALL);
ini_set('display_errors', 1);

// تحقق مما إذا كان هناك إجراء محدد
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['action'])) {
    // جلب الأقسام
    if ($_GET['action'] === 'departments') {
        try {
            $stmt = $conn->prepare("SELECT id, department_name FROM departments");
            $stmt->execute();
            $departments = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(['status' => 'success', 'departments' => $departments]);
        } catch (Exception $e) {
            echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
        }
    }
    // جلب الكورسات بناءً على القسم
    // جلب الكورسات بناءً على القسم
elseif ($_GET['action'] === 'courses' && isset($_GET['department_id'])) {
    try {
        $department_id = $_GET['department_id'];
        $stmt = $conn->prepare("
            SELECT c.id, c.course_name, c.duration, c.state, p.price 
            FROM courses c 
            JOIN course_prices p ON c.id = p.course_id 
            WHERE c.department_id = :department_id
        "); // تعديل الاستعلام
        $stmt->bindParam(':department_id', $department_id, PDO::PARAM_INT);
        $stmt->execute();
        $courses = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['status' => 'success', 'courses' => $courses]);
    } catch (Exception $e) {
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
}
    else {
        // إذا كانت الطلب غير معروف
        echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'No action specified']);
}

// إغلاق الاتصال
$conn = null;
?>