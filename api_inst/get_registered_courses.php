<?php
header("Content-Type: application/json; charset=UTF-8");
require_once 'db.php';

$response = ['success' => false, 'message' => '', 'courses' => []];

if (!isset($_GET['student_id']) || !is_numeric($_GET['student_id'])) {
    $response['message'] = 'Invalid student ID';
    echo json_encode($response);
    exit;
}

$studentId = (int)$_GET['student_id'];

try {
    $stmt = $conn->prepare("
        SELECT 
            c.id as course_id,
            c.course_name as name,
            c.duration,
            d.department_name
        FROM course_session_students css
        JOIN course_sessions cs ON css.course_session_id = cs.id
        JOIN courses c ON cs.course_id = c.id
        JOIN departments d ON c.department_id = d.id
        WHERE css.student_id = ? 
        AND css.status != 'dropped'
        GROUP BY c.id
    ");
    
    $stmt->execute([$studentId]);
    $courses = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    $response['success'] = true;
    $response['courses'] = $courses;
} catch (PDOException $e) {
    $response['message'] = 'Database error: ' . $e->getMessage();
}

echo json_encode($response);
?>