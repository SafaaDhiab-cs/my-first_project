<?php
header("Content-Type: application/json; charset=UTF-8");
require_once 'db.php';

$studentId = isset($_POST['student_id']) ? intval($_POST['student_id']) : 0;

if ($studentId <= 0) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid student ID'
    ]);
    exit;
}

try {
    $stmt = $conn->prepare("
        UPDATE student_notifications 
        SET state = 'read' 
        WHERE student_id = ? AND state = 'unread'
    ");
    $stmt->execute([$studentId]);

    echo json_encode([
        'success' => true,
        'message' => 'All notifications marked as read'
    ]);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>