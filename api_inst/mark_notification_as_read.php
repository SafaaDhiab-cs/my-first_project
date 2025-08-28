<?php
header("Content-Type: application/json; charset=UTF-8");
require_once 'db.php';

$notificationId = isset($_POST['notification_id']) ? intval($_POST['notification_id']) : 0;

if ($notificationId <= 0) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid notification ID'
    ]);
    exit;
}

try {
    $stmt = $conn->prepare("
        UPDATE student_notifications 
        SET state = 'read' 
        WHERE id = ?
    ");
    $stmt->execute([$notificationId]);

    echo json_encode([
        'success' => true,
        'message' => 'Notification marked as read'
    ]);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>