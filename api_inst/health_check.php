<?php
header("Content-Type: application/json");

try {
    // استدعاء ملف الاتصال الذي يرجع كائن PDO
    $conn = require_once 'db.php';
    
    // اختبار اتصال بسيط باستخدام الكائن الذي تم إرجاعه
    $conn->query("SELECT 1");
    
    echo json_encode([
        'status' => 'ok',
        'server_time' => date('Y-m-d H:i:s'),
        'database' => 'connected',
        'database_name' => $conn->getAttribute(PDO::ATTR_DRIVER_NAME) // إضافة معلومات إضافية عن الاتصال
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed',
        'error' => $e->getMessage()
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'An error occurred',
        'error' => $e->getMessage()
    ]);
}
?>