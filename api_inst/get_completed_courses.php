<?php
header("Content-Type: application/json");
require_once 'db.php';

$studentId = $_GET['student_id'] ?? 0;

try {
    $query = "
        SELECT 
            css.course_session_id,
            cs.course_id,
            c.course_name,
            IF(ce.id IS NULL, 0, 1) AS is_rated
        FROM 
            course_session_students css
        JOIN 
            course_sessions cs ON css.course_session_id = cs.id
        JOIN 
            courses c ON cs.course_id = c.id
        LEFT JOIN 
            course_evaluations ce ON ce.course_session_id = css.course_session_id 
            AND ce.student_id = css.student_id
        WHERE 
            css.student_id = :student_id 
            AND css.status = 'completed'
    ";

    $stmt = $conn->prepare($query);
    $stmt->bindParam(':student_id', $studentId, PDO::PARAM_INT);
    $stmt->execute();

    $courses = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'courses' => $courses
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
    error_log("Database error: " . $e->getMessage());
}
?>