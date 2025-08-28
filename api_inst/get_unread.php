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
        SELECT COUNT(*) as count 
        FROM student_notifications 
        WHERE student_id = ? AND state = 'unread'
    ");
    $stmt->execute([$studentId]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'count' => (int)$result['count']
    ]);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>