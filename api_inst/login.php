<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

require_once "db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['email']) || !isset($data['password'])) {
    echo json_encode(['success' => false, 'message' => 'بيانات غير مكتملة']);
    exit;
}

try {
    // أولاً: جلب المستخدم مع كلمة المرور المشفرة من قاعدة البيانات
    $stmt = $conn->prepare("
        SELECT u.id, u.name, u.email, u.password, s.id as student_id
        FROM users u
        JOIN students s ON u.id = s.user_id
        WHERE u.email = ?
    ");
    
    $stmt->execute([$data['email']]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        // التحقق من كلمة المرور باستخدام password_verify
        if (password_verify($data['password'], $user['password'])) {
            echo json_encode([
                'success' => true,
                'message' => 'تم تسجيل الدخول بنجاح',
                'data' => [
                    'user_id' => $user['id'],
                    'name' => $user['name'],
                    'student_id' => $user['student_id']
                ]
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'message' => 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
            ]);
        }
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
        ]);
    }
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'خطأ في قاعدة البيانات'
    ]);
}
?>