<?php
header("Content-Type: application/json; charset=UTF-8");
require_once 'db.php';

$studentId = isset($_GET['student_id']) ? intval($_GET['student_id']) : 0;

if ($studentId <= 0) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid student ID'
    ]);
    exit;
}

try {
    $stmt = $conn->prepare("
        SELECT id, student_id, note, state, date 
        FROM student_notifications 
        WHERE student_id = ?
        ORDER BY 
            CASE WHEN state = 'unread' THEN 0 ELSE 1 END,
            date DESC
    ");
    $stmt->execute([$studentId]);
    $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // حساب عدد الإشعارات غير المقروءة
    $unreadCount = 0;
    foreach ($notifications as $notification) {
        if ($notification['state'] === 'unread') {
            $unreadCount++;
        }
    }

    echo json_encode([
        'success' => true,
        'notifications' => $notifications,
        'unread_count' => $unreadCount
    ]);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>