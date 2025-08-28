<?php
header("Content-Type: application/json; charset=utf-8");
require_once 'db.php';

// تسجيل البيانات الواردة للتصحيح
file_put_contents('debug_password.log', 
    "Request Time: " . date('Y-m-d H:i:s') . "\n" .
    "Request Data: " . file_get_contents("php://input") . "\n\n",
    FILE_APPEND);

$data = json_decode(file_get_contents("php://input"), true);

if (json_last_error() !== JSON_ERROR_NONE) {
    echo json_encode([
        'success' => false,
        'message' => 'خطأ في تحليل بيانات JSON: ' . json_last_error_msg()
    ]);
    exit;
}

$userId = (int)($data['user_id'] ?? 0);
$oldPassword = trim($data['old_password'] ?? '');
$newPassword = trim($data['new_password'] ?? '');

if ($userId <= 0 || empty($oldPassword) || empty($newPassword)) {
    echo json_encode([
        'success' => false,
        'message' => 'جميع الحقول مطلوبة',
        'received_data' => $data // لأغراض التصحيح
    ]);
    exit;
}

try {
    // 1. جلب بيانات المستخدم
    $stmt = $conn->prepare("SELECT id, password FROM users WHERE id = ?");
    $stmt->execute([$userId]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        echo json_encode([
            'success' => false,
            'message' => 'المستخدم غير موجود',
            'user_id' => $userId
        ]);
        exit;
    }

    // 2. التحقق من كلمة المرور القديمة
    if (!password_verify($oldPassword, $user['password'])) {
        file_put_contents('password_attempts.log', 
            "Failed password attempt for user $userId at " . date('Y-m-d H:i:s') . "\n" .
            "Input Hash: " . password_hash($oldPassword, PASSWORD_DEFAULT) . "\n" .
            "Stored Hash: " . $user['password'] . "\n\n",
            FILE_APPEND);
        
        echo json_encode([
            'success' => false,
            'message' => 'كلمة المرور الحالية غير صحيحة',
            'debug' => [
                'input_length' => strlen($oldPassword),
                'stored_length' => strlen($user['password']),
                'input_first_chars' => substr($oldPassword, 0, 3),
                'stored_first_chars' => substr($user['password'], 0, 3),
            ]
        ]);
        exit;
    }

    // 3. تحديث كلمة المرور الجديدة
    $hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT, ['cost' => 12]);
    
    $updateStmt = $conn->prepare("UPDATE users SET password = ? WHERE id = ?");
    $updateStmt->execute([$hashedPassword, $userId]);

    file_put_contents('password_changes.log', 
        "Password changed for user $userId at " . date('Y-m-d H:i:s') . "\n",
        FILE_APPEND);

    echo json_encode([
        'success' => true,
        'message' => 'تم تغيير كلمة المرور بنجاح'
    ]);

} catch (PDOException $e) {
    error_log("Database Error: " . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'حدث خطأ في الخادم',
        'error_details' => $e->getMessage()
    ]);
}
?>